import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/features/challenges/data/models/game_model.dart';
import 'package:linkati/features/challenges/data/models/question_model.dart';
import 'package:linkati/features/challenges/presentation/cubit/challenges_cubit.dart';
import 'package:linkati/features/users/data/models/user_model.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../../../core/api/app_collections.dart';
import '../../../../core/widgets/alert_widget.dart';
import '../views/game_content_view.dart';
import '../views/winner_view.dart';

class GameScreen extends StatefulWidget {
  final GameModel game;
  final List<QuestionModel> questions;

  const GameScreen({
    super.key,
    required this.game,
    required this.questions,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<QuestionModel> questions = [];
  late GameModel game;
  late QuestionModel _currentQuestion;

  bool isMyTurn = false;

  late ChallengesCubit _challengesCubit;
  late UsersCubit _usersCubit;

  UserModel player1 = UserModel.isEmpty();
  UserModel player2 = UserModel.isEmpty();

  @override
  void initState() {
    super.initState();
    questions.addAll(widget.questions);
    game = widget.game;
    _challengesCubit = context.read<ChallengesCubit>();
    _usersCubit = context.read<UsersCubit>();
    _currentQuestion = _getCurrentQuestion(game);
  }

  QuestionModel _getCurrentQuestion(GameModel game) {
    if (questions.isEmpty) return QuestionModel.isEmpty();
    return questions.firstWhere(
      (question) => question.id == game.currntQuestionId,
      orElse: () => questions.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (game.endedAt != null) {
          return true;
        }
        return await AppAlert.showExitConfirmationDialog(
          context,
          onConfirm: () {
            _challengesCubit.endGameEvent(widget.game);
          },
        );
      },
      child: StreamBuilder<DocumentSnapshot>(
        stream: instance<AppCollections>().games.doc(game.id).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            game = GameModel.fromJson(
              snapshot.data!.data() as Map<String, dynamic>,
            );
            _currentQuestion = _getCurrentQuestion(game);

            isMyTurn = game.currentTurnPlayerId ==
                    FirebaseAuth.instance.currentUser!.uid ||
                game.isWithAi;
          }

          // التحقق من انتهاء الأسئلة
          if (game.currentQuestionNumber >= game.questionCount ||
              game.endedAt != null) {
            return WinnerView(
              game: game,
              challengesCubit: _challengesCubit,
              usersCubit: _usersCubit,
            );
          }

          return GameContentView(
            game: game,
            challengesCubit: _challengesCubit,
            isMyTurn: isMyTurn,
            isMePlayer1: game.isMePlayer1,
            usersCubit: _usersCubit,
            currentQuestion: _currentQuestion,
            onSubmitAnswer: (String answer) => _onConfirmAnswer(answer),
          );
        },
      ),
    );
  }

  void _onConfirmAnswer(String answer) {
    bool isCorrect = answer == _currentQuestion.correctAnswer;
    bool isLastQuestion = game.currentQuestionNumber >= game.questionCount;

    int currentQuestionNumber = game.currentQuestionNumber;

    String currntQuestionId = game.currntQuestionId;

    if ((isCorrect || game.isWithAi) &&
        !isLastQuestion &&
        currentQuestionNumber < questions.length) {
      // next question
      _currentQuestion = questions[game.currentQuestionNumber + 1];
      currntQuestionId = _currentQuestion.id;
      currentQuestionNumber = game.currentQuestionNumber + 1;
    }

    game = game.copyWith(
      player1: game.isMePlayer1
          ? game.player1.copyWith(
              score: isCorrect ? game.player1.score + 1 : game.player1.score,
              correctAnswer: isCorrect ? null : answer,
            )
          : game.player1,
      player2: game.isWithAi
          ? game.otherPlayer.copyWith(
              score: !isCorrect ? game.player2!.score + 1 : game.player2!.score,
              correctAnswer: !isCorrect ? null : answer,
            )
          : game.isMePlayer1
              ? game.player2
              : game.player2!.copyWith(
                  score:
                      isCorrect ? game.player2!.score + 1 : game.player2!.score,
                  correctAnswer: isCorrect ? null : answer,
                ),
      currentTurnPlayerId: isCorrect ? null : game.otherPlayer.userId,
      currntQuestionId: currntQuestionId,
      currentQuestionNumber: currentQuestionNumber,
    );

    _challengesCubit.updateGameEvent(game);

    if (isCorrect) {
      _usersCubit.incrementScoreEvent(
        FirebaseAuth.instance.currentUser!.uid,
      );
    }

    isLastQuestion = game.currentQuestionNumber >= game.questionCount;

    if (isLastQuestion) {
      _challengesCubit.endGameEvent(game);
    }
  }
}
