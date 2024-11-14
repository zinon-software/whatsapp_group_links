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
import '../../../../core/widgets/custom_button_widget.dart';
import '../widgets/player_widget.dart';

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
    return widget.questions.firstWhere(
      (question) => question.id == game.currntQuestionId,
      orElse: () => widget.questions.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog(context);
      },
      child: StreamBuilder<DocumentSnapshot>(
        stream: instance<AppCollections>().games.doc(game.id).snapshots(),
        builder: (context, snapshot) {
          // if (snapshot.hasError) {
          //   return Scaffold(body: Center(child: Text('خطأ في تحميل البيانات')));
          // }
          // if (snapshot.connectionState == ConnectionState.waiting &&
          //     _currentQuestion == null) {
          //   return Scaffold(body: Center(child: CircularProgressIndicator()));
          // }

          if (snapshot.hasData && snapshot.data!.data() != null) {
            game = GameModel.fromJson(
              snapshot.data!.data() as Map<String, dynamic>,
            );
            _currentQuestion = _getCurrentQuestion(game);

            isPlayerTurn = game.currentTurnPlayerId ==
                FirebaseAuth.instance.currentUser!.uid;
          }

          // التحقق من انتهاء الأسئلة
          if (game.currentQuestionNumber >= widget.questions.length) {
            return WinnerView(game: game, challengesCubit: _challengesCubit);
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'السؤال ${game.currentQuestionNumber + 1} من ${widget.questions.length}',
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PlayerWidget(
                        isMe: isMePlayer1,
                        isHost: game.currentTurnPlayerId == game.player1.userId,
                        player: game.player1,
                        usersCubit: _usersCubit,
                        gameId: game.id,
                      ),
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            "assets/images/vs.png",
                            height: 90,
                            width: 90,
                          ),
                        ),
                      ),
                      PlayerWidget(
                        isMe: !isMePlayer1,
                        isHost:
                            game.currentTurnPlayerId == game.player2!.userId,
                        player: game.player2!,
                        usersCubit: _usersCubit,
                        gameId: game.id,
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(
                    _currentQuestion.question,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: List.generate(
                      _currentQuestion.options.length,
                      (index) {
                        return InkWell(
                          onTap: isPlayerTurn
                              ? () {
                                  _onConfirmAnswer(
                                    _currentQuestion.options[index],
                                  );
                                }
                              : null,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.only(bottom: 8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    isPlayerTurn ? Colors.green : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 8.0),
                                Text(_currentQuestion.options[index]),
                                const Spacer(),
                                if (game.correctAnswerPlayer1 ==
                                    _currentQuestion.options[index])
                                  Icon(
                                    Icons.check,
                                    color: isPlayerTurn
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                if (game.correctAnswerPlayer2 ==
                                    _currentQuestion.options[index])
                                  Icon(
                                    Icons.check,
                                    color: isPlayerTurn
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButtonWidget(
                    radius: 100,
                    height: 60,
                    width: 60,
                    backgroundColor: isPlayerTurn ? Colors.green : Colors.grey,
                    enableClick: game.currentTurnPlayerId == null,
                    onPressed: game.currentTurnPlayerId == null
                        ? () {
                            _challengesCubit.updateGameEvent(game.copyWith(
                              currentTurnPlayerId:
                                  FirebaseAuth.instance.currentUser!.uid,
                            ));
                          }
                        : null,
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text('انقر للحصول على الدور'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onConfirmAnswer(String answer) {
    bool isCorrect = answer == _currentQuestion.correctAnswer;
    bool isLastQuestion =
        game.currentQuestionNumber == widget.questions.length - 1;

    if (isCorrect && !isLastQuestion) {
      // next question
      _currentQuestion = widget.questions[game.currentQuestionNumber + 1];
    }

    game = game.copyWith(
      player1: isMePlayer1
          ? game.player1.copyWith(
              score: isCorrect ? game.player1.score + 1 : game.player1.score)
          : game.player1,
      player2: isMePlayer1
          ? game.player2
          : game.player2!.copyWith(
              score: isCorrect ? game.player2!.score + 1 : game.player2!.score),
      correctAnswerPlayer1:
          isCorrect && game.currentTurnPlayerId == game.player1.userId
              ? answer
              : game.correctAnswerPlayer1,
      correctAnswerPlayer2:
          isCorrect && game.currentTurnPlayerId == game.player2?.userId
              ? answer
              : game.correctAnswerPlayer2,
      currentTurnPlayerId: isCorrect
          ? null
          : isMePlayer1
              ? game.player2?.userId
              : game.player1.userId,
      currntQuestionId: isCorrect ? _currentQuestion.id : game.currntQuestionId,
      currentQuestionNumber: isCorrect
          ? game.currentQuestionNumber + 1
          : game.currentQuestionNumber,
    );
    _challengesCubit.updateGameEvent(game);
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await AppAlert.showAlert(
      context,
      title: 'تأكيد الخروج',
      subTitle: 'هل تريد الخروج من اللعبة؟',
      confirmText: 'نعم، خروج',
      dismissOn: false,
      onConfirm: () {
        _challengesCubit.endGameEvent(widget.game);
        Navigator.of(context).pop(true);
      },
      cancelText: 'اغلاق',
      onCancel: () => Navigator.of(context).pop(false),
    );
  }
}

class WinnerView extends StatelessWidget {
  const WinnerView({
    super.key,
    required this.game,
    required this.challengesCubit,
  });

  final GameModel game;
  final ChallengesCubit challengesCubit;

  @override
  Widget build(BuildContext context) {
    String winnerMessage;
    if (game.player1.score > (game.player2?.score ?? 0)) {
      winnerMessage = "اللاعب الأول فاز!";
    } else if (game.player2 != null &&
        game.player2!.score > game.player1.score) {
      winnerMessage = "اللاعب الثاني فاز!";
    } else {
      winnerMessage = "التعادل!";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('النتيجة'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'نتيجة اللعبة',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              winnerMessage,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            CustomButtonWidget(
              label: 'اغلاق',
              radius: 10,
              height: 50,
              width: 200,
              onPressed: () {
                challengesCubit.endGameEvent(game);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
