import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkati/features/challenges/data/models/question_model.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../../../core/widgets/custom_button_widget.dart';
import '../../data/models/game_model.dart';
import '../cubit/challenges_cubit.dart';
import '../widgets/player_widget.dart';

class GameContentView extends StatelessWidget {
  const GameContentView({
    super.key,
    required this.game,
    required this.challengesCubit,
    required this.isPlayerTurn,
    required this.isMePlayer1,
    required this.usersCubit,
    required this.currentQuestion,
    required this.onSubmitAnswer,
  });

  final GameModel game;
  final ChallengesCubit challengesCubit;
  final bool isPlayerTurn;
  final bool isMePlayer1;
  final UsersCubit usersCubit;
  final QuestionModel currentQuestion;
  final Function(String answer) onSubmitAnswer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'السؤال ${game.currentQuestionNumber + 1} من ${game.questionCount}',
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
                  isAi: false,
                  player: game.player1,
                  usersCubit: usersCubit,
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
                  isHost: game.currentTurnPlayerId == game.player2!.userId,
                  isAi: game.isWithAi,
                  player: game.player2!,
                  usersCubit: usersCubit,
                  gameId: game.id,
                )
              ],
            ),
            SizedBox(height: 30),
            Text(
              currentQuestion.question,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            QuestionOptions(
              currentQuestion: currentQuestion,
              isPlayerTurn: isPlayerTurn,
              onSelectAnswer: onSubmitAnswer,
              game: game,
            ),
            const SizedBox(height: 20),
            if (!game.isWithAi) ...[
              CustomButtonWidget(
                radius: 100,
                height: 60,
                width: 60,
                backgroundColor: isPlayerTurn
                    ? Colors.green
                    : game.currentTurnPlayerId != null
                        ? Colors.red
                        : Colors.grey,
                enableClick: game.currentTurnPlayerId == null,
                onPressed: game.currentTurnPlayerId == null
                    ? () {
                        challengesCubit.updateGameEvent(game.copyWith(
                          currentTurnPlayerId:
                              FirebaseAuth.instance.currentUser!.uid,
                        ));
                      }
                    : null,
                child: Icon(Icons.check, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text('انقر للحصول على الدور'),
            ]
          ],
        ),
      ),
    );
  }
}

class QuestionOptions extends StatefulWidget {
  const QuestionOptions({
    super.key,
    required this.currentQuestion,
    required this.isPlayerTurn,
    required this.onSelectAnswer,
    required this.game,
  });

  final QuestionModel currentQuestion;
  final bool isPlayerTurn;
  final Function(String answer) onSelectAnswer;
  final GameModel game;

  @override
  State<QuestionOptions> createState() => _QuestionOptionsState();
}

class _QuestionOptionsState extends State<QuestionOptions> {
  int? selectedIndex;
  bool showAnswerFeedback = false;

  @override
  void didUpdateWidget(covariant QuestionOptions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentQuestion != widget.currentQuestion) {
      // إعادة تعيين الحالة عند تغيير السؤال
      setState(() {
        selectedIndex = null;
        showAnswerFeedback = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.currentQuestion.options.length,
        (index) {
          final isCorrectAnswer = widget.currentQuestion.correctAnswer ==
              widget.currentQuestion.options[index];
          final isSelected = selectedIndex == index;

          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: widget.isPlayerTurn ? 1 : 0.5,
            child: GestureDetector(
              onTap: widget.isPlayerTurn
                  ? () async {
                      setState(() {
                        selectedIndex = index;
                        showAnswerFeedback = true;
                      });

                      // تأخير لعرض التغذية الراجعة (Feedback)
                      await Future.delayed(const Duration(milliseconds: 500));

                      setState(() {
                        showAnswerFeedback = false;
                      });

                      widget.onSelectAnswer(
                        widget.currentQuestion.options[index],
                      );
                    }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? (isCorrectAnswer ? Colors.green : Colors.red)
                        : (widget.isPlayerTurn ? Colors.green : Colors.grey),
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  color: isSelected
                      ? (isCorrectAnswer
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2))
                      : Colors.transparent,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8.0),
                    Text(widget.currentQuestion.options[index]),
                    const Spacer(),
                    if (showAnswerFeedback && isSelected)
                      Icon(
                        isCorrectAnswer ? Icons.check : Icons.close,
                        color: isCorrectAnswer ? Colors.green : Colors.red,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
