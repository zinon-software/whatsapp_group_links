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
  late GameModel game;
  bool isPlayerTurn = false;

  bool isMePlayer1 = false;
  late ChallengesCubit _challengesCubit;
  late UsersCubit _usersCubit;
  late QuestionModel _currentQuestion;
  UserModel player1 = UserModel.isEmpty();
  UserModel player2 = UserModel.isEmpty();

  @override
  void initState() {
    super.initState();
    game = widget.game;
    _challengesCubit = context.read<ChallengesCubit>();
    _usersCubit = context.read<UsersCubit>();
    _currentQuestion = _getCurrentQuestion(game);
    isMePlayer1 = game.player1.userId == FirebaseAuth.instance.currentUser!.uid;
  }

  QuestionModel _getCurrentQuestion(GameModel game) {
    if (widget.questions.isEmpty) return QuestionModel.isEmpty();
    return widget.questions.firstWhere(
      (question) => question.id == game.currntQuestionId,
      orElse: () => widget.questions.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return await AppAlert.showExitConfirmationDialog(context).then((value) {
          if (value) _challengesCubit.endGameEvent(widget.game);
          return value;
        });
      },
      child: StreamBuilder<DocumentSnapshot>(
        stream: instance<AppCollections>().games.doc(game.id).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            game = GameModel.fromJson(
              snapshot.data!.data() as Map<String, dynamic>,
            );
            _currentQuestion = _getCurrentQuestion(game);

            isPlayerTurn = game.currentTurnPlayerId ==
                    FirebaseAuth.instance.currentUser!.uid ||
                game.isWithAi;
          }

          // التحقق من انتهاء الأسئلة
          if (game.currentQuestionNumber >= widget.questions.length ||
              game.endedAt != null) {
            return WinnerView(game: game, challengesCubit: _challengesCubit);
          }

          return GameContentView(
            game: game,
            challengesCubit: _challengesCubit,
            isPlayerTurn: isPlayerTurn,
            isMePlayer1: isMePlayer1,
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
    bool isLastQuestion =
        game.currentQuestionNumber == widget.questions.length - 1;

    if ((isCorrect || game.isWithAi) && !isLastQuestion) {
      // next question
      _currentQuestion = widget.questions[game.currentQuestionNumber + 1];
    }

    game = game.copyWith(
      player1: isMePlayer1
          ? game.player1.copyWith(
              score: isCorrect ? game.player1.score + 1 : game.player1.score,
            )
          : game.player1,
      player2: game.isWithAi
          ? game.player2!.copyWith(
              score: !isCorrect ? game.player2!.score + 1 : game.player2!.score,
            )
          : isMePlayer1
              ? game.player2
              : game.player2!.copyWith(
                  score:
                      isCorrect ? game.player2!.score + 1 : game.player2!.score,
                ),
      correctAnswerPlayer1: isCorrect
          ? null
          : isMePlayer1
              ? answer
              : game.correctAnswerPlayer1,
      correctAnswerPlayer2: isCorrect
          ? null
          : isMePlayer1
              ? game.correctAnswerPlayer2
              : answer,
      currentTurnPlayerId: isCorrect
          ? null
          : isMePlayer1
              ? game.player2?.userId
              : game.player1.userId,
      currntQuestionId: isCorrect || game.isWithAi
          ? _currentQuestion.id
          : game.currntQuestionId,
      currentQuestionNumber: isCorrect || game.isWithAi
          ? game.currentQuestionNumber + 1
          : game.currentQuestionNumber,
    );

    _challengesCubit.updateGameEvent(game);

    if (isCorrect) {
      _usersCubit.incrementScoreEvent(
        FirebaseAuth.instance.currentUser!.uid,
      );
    }
  }
}
