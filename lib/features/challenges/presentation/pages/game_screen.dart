import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/features/challenges/data/models/game_model.dart';
import 'package:linkati/features/challenges/data/models/question_model.dart';
import 'package:linkati/features/challenges/presentation/cubit/challenges_cubit.dart';

import '../../../../core/api/app_collections.dart';

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
  late ChallengesCubit _challengesCubit;
  late QuestionModel _currentQuestion;

  @override
  void initState() {
    super.initState();
    game = widget.game;
    _challengesCubit = context.read<ChallengesCubit>();
    _currentQuestion = _getCurrentQuestion(game);
  }

  // دالة لتحديد السؤال الحالي
  QuestionModel _getCurrentQuestion(GameModel game) {
    
    return widget.questions.firstWhere(
      (question) => question.id == game.currntQuestionId,
      orElse: () => widget.questions.first, // احتياطيًا في حال عدم العثور
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: instance<AppCollections>().games.doc(game.id).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('خطأ في تحميل البيانات'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.data() != null) {
          // تحديث `GameModel` و`currentQuestion` عند كل تغيير
          game = GameModel.fromJson(
            snapshot.data!.data() as Map<String, dynamic>,
          );
          _currentQuestion = _getCurrentQuestion(game);

          // تحديث حالة اللعبة في `ChallengesCubit`
          // _challengesCubit.updateGameEvent(game);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
                'السؤال ${game.currentQuestionNumber + 1} من ${widget.questions.length}'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isPlayerTurn ? Colors.grey : Colors.green,
                          ),
                          onPressed: () {
                            if (isPlayerTurn) {
                              _onConfirmAnswer(_currentQuestion.options[index]);
                            }
                          },
                          child: Text(_currentQuestion.options[index]),
                        ),
                      );

                      // RadioListTile<String>(
                      //   title: Text(currentQuestion.options[index]),
                      //   value: currentQuestion.options[index],
                      //   groupValue: currentQuestion.correctAnswer,
                      //   onChanged: (String? value) {
                      //     if (isPlayerTurn && value != null) {
                      //       _onConfirmAnswer(value);
                      //     }
                      //   },
                      // );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: !isPlayerTurn
                      ? () {
                          setState(() {
                            isPlayerTurn = true;
                          });
                        }
                      : null,
                  child: const Text('انقر للحصول على الدور'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _switchTurn() {
    isPlayerTurn = false;
    game = game.copyWith(
      currentTurnPlayerId: game.currentTurnPlayerId == game.player1.userId
          ? game.player2?.userId
          : game.player1.userId,
    );
    _challengesCubit.updateGameEvent(game);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onConfirmAnswer(String answer) {
    bool isCorrect = answer == _currentQuestion.correctAnswer;

    if (isCorrect) {
      // next question
      _currentQuestion = widget.questions[game.currentQuestionNumber + 1];
    }

    game = game.copyWith(
      correctAnswerPlayer1:
          isCorrect && game.currentTurnPlayerId == game.player1.userId
              ? answer
              : game.correctAnswerPlayer1,
      correctAnswerPlayer2:
          isCorrect && game.currentTurnPlayerId == game.player2?.userId
              ? answer
              : game.correctAnswerPlayer2,
      currentTurnPlayerId: game.currentTurnPlayerId == game.player1.userId
          ? game.player2?.userId
          : game.player1.userId,
      currntQuestionId: isCorrect ? _currentQuestion.id : game.currntQuestionId,
      currentQuestionNumber: game.currentQuestionNumber + 1,
    );
    _switchTurn();
  }
}
