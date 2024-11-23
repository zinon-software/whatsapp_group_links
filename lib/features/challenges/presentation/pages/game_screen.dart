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

import '../../../../core/ads/ads_manager.dart';
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
  late final AdsManager _adManager;
  final List<QuestionModel> questions = [];
  final List<String> _usedQuestionIds = []; // قائمة لتتبع الأسئلة المستخدمة
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
    _adManager = AdsManager();
    questions.addAll(widget.questions);
    game = widget.game;
    _challengesCubit = context.read<ChallengesCubit>();
    _usersCubit = context.read<UsersCubit>();
    _currentQuestion = _getCurrentQuestion(game);

    _adManager.loadBannerAd();
  }

  QuestionModel _getCurrentQuestion(GameModel game) {
    if (questions.isEmpty) return QuestionModel.isEmpty();
    return questions.firstWhere(
      (question) => question.id == game.currntQuestionId,
      orElse: () => questions.first,
    );
  }

  QuestionModel _getRandomQuestion() {
    final availableQuestions = questions
        .where((q) =>
            !_usedQuestionIds.contains(q.id)) // تصفية الأسئلة غير المستخدمة
        .toList();

    if (availableQuestions.isEmpty) {
      // إذا لم تتبقَ أسئلة، يمكن إنهاء اللعبة أو إعادة التعيين
      return QuestionModel.isEmpty();
    }

    return availableQuestions[availableQuestions.length - 1];
  }

  Future<void> _getAiRandomAnswer() async {
    await Future.delayed(Duration(seconds: 1));

    final options = [
      _currentQuestion.options[0],
      _currentQuestion.options[1],
      _currentQuestion.options[2],
      _currentQuestion.options[3],
    ];
    options.shuffle(); // ترتيب عشوائي
    String answer = options.first; // اختيار أول خيار بعد الترتيب العشوائي
    _onConfirmAnswer(answer, isAiAnswer: true);
  }

  void _onConfirmAnswer(String answer, {bool isAiAnswer = false}) {
    // أضف السؤال الحالي إلى قائمة المستخدمين
    if (!_usedQuestionIds.contains(_currentQuestion.id)) {
      _usedQuestionIds.add(_currentQuestion.id);
    }
    bool isCorrect = answer == _currentQuestion.correctAnswer;
    bool isLastQuestion = game.currentQuestionNumber >= game.questionCount;

    if (isCorrect) {
      // اختر سؤالاً عشوائياً جديداً
      _currentQuestion = _getRandomQuestion();
      game = game.copyWith(
        currntQuestionId: _currentQuestion.id,
        currentQuestionNumber: game.currentQuestionNumber + 1,
      );
    }

    // تحديث بيانات اللعبة
    game = game.copyWith(
      player1: game.isMePlayer1 && !isAiAnswer
          ? game.player1.copyWith(
              score: isCorrect ? game.player1.score + 1 : game.player1.score,
              correctAnswer: isCorrect ? null : answer,
            )
          : game.player1.copyWith(
              correctAnswer: isCorrect ? null : game.player1.correctAnswer,
            ),
      player2: game.isMePlayer1 && !isAiAnswer
          ? game.player2!.copyWith(
              correctAnswer: isCorrect ? null : game.player2!.correctAnswer,
            )
          : game.player2!.copyWith(
              score: isCorrect ? game.player2!.score + 1 : game.player2!.score,
              correctAnswer: isCorrect ? null : answer,
            ),
      currentTurnPlayerId: isCorrect
          ? null
          : isAiAnswer
              ? game.player1.userId
              : game.otherPlayer.userId,
    );

    _challengesCubit.updateGameEvent(game);

    if (isCorrect && !isAiAnswer) {
      _usersCubit.incrementScoreEvent();
    }

    if (isLastQuestion) {
      _challengesCubit.endGameEvent(game);
    }
  }

  @override
  void dispose() {
    _adManager.disposeBannerAds();
    super.dispose();
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

            if (!_usedQuestionIds.contains(_currentQuestion.id)) {
              _usedQuestionIds.add(_currentQuestion.id);
            }

            isMyTurn = game.currentTurnPlayerId ==
                FirebaseAuth.instance.currentUser!.uid;

            if (game.isWithAi &&
                game.currentTurnPlayerId == game.otherPlayer.userId) {
              _getAiRandomAnswer();
            } else if (game.isWithAi) {
              isMyTurn = true;
            }
          }

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
            adBannerWidget: _adManager.getBannerAdWidget(
              padding: const EdgeInsets.all(8.0),
            ),
          );
        },
      ),
    );
  }
}
