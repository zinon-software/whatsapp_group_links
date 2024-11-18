import 'dart:math';
import 'package:audioplayers/audioplayers.dart'; // استيراد مكتبة الصوت

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
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
    required this.isMyTurn,
    required this.isMePlayer1,
    required this.usersCubit,
    required this.currentQuestion,
    required this.onSubmitAnswer,
  });

  final GameModel game;
  final ChallengesCubit challengesCubit;
  final bool isMyTurn;
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
            QuestionOptionsWidget(
              currentQuestion: currentQuestion,
              isPlayerTurn: isMyTurn,
              onSelectAnswer: onSubmitAnswer,
              opponentAnswer: game.otherPlayer.correctAnswer,
            ),
            const SizedBox(height: 20),
            if (!game.isWithAi) ...[
              isMyTurn
                  ? CircularCountDownTimer(
                      duration: 20,
                      initialDuration: 0,
                      controller: CountDownController(),
                      width: 60, // عرض المؤقت
                      height: 60, // ارتفاع المؤقت
                      ringColor: Colors.grey[300]!,
                      fillColor: Colors.green,
                      backgroundColor: Colors.white,
                      strokeWidth: 10.0,
                      strokeCap: StrokeCap.round,
                      textStyle: const TextStyle(
                        fontSize: 22.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textFormat: CountdownTextFormat.S,
                      isReverse: true, // للعد التنازلي
                      isTimerTextShown: true,
                      autoStart: true, // تشغيل المؤقت تلقائيًا
                      onComplete: () {
                        // عند انتهاء المؤقت بدون إجابة، يتم نقل الدور للطرف الآخر
                        challengesCubit.updateGameEvent(game.copyWith(
                          currentTurnPlayerId:
                              game.currentTurnPlayerId == game.player1.userId
                                  ? game.player2?.userId
                                  : game.player1.userId,
                        ));
                      },
                    )
                  : CustomButtonWidget(
                      radius: 100,
                      height: 60,
                      width: 60,
                      backgroundColor: isMyTurn
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
                      child: const Icon(Icons.check, color: Colors.white),
                    ),
              const SizedBox(height: 8),
              const Text('انقر للحصول على الدور'),
            ]
          ],
        ),
      ),
    );
  }
}


class QuestionOptionsWidget extends StatefulWidget {
  const QuestionOptionsWidget({
    super.key,
    required this.currentQuestion,
    required this.isPlayerTurn,
    required this.onSelectAnswer,
    this.opponentAnswer,
  });

  final QuestionModel currentQuestion;
  final bool isPlayerTurn;
  final Function(String answer) onSelectAnswer;
  final String? opponentAnswer; // إجابة الطرف الآخر

  @override
  State<QuestionOptionsWidget> createState() => _QuestionOptionsWidgetState();
}

class _QuestionOptionsWidgetState extends State<QuestionOptionsWidget> {
  int? selectedIndex;
  bool showAnswerFeedback = false;
  int? opponentSelectedIndex; // مؤشر الخيار الذي اختاره الطرف الآخر
  late AudioPlayer _audioPlayer; // متغير لتشغيل الصوت

  List<String> shuffledOptions = []; // قائمة جديدة للخيارات المخلوطة

  @override
  void initState() {
    super.initState();

    shuffledOptions = List.from(
      widget.currentQuestion.options,
    ); // نسخ الخيارات الأصلية
    shuffledOptions.shuffle(Random()); // خلط الخيارات عشوائيًا
    _audioPlayer = AudioPlayer(); // تهيئة مشغل الصوت
  }

  @override
  void didUpdateWidget(covariant QuestionOptionsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentQuestion != widget.currentQuestion) {
      // إعادة تعيين الحالة عند تغيير السؤال
      setState(() {
        selectedIndex = null;
        opponentSelectedIndex = null;
        showAnswerFeedback = false;
        shuffledOptions = List.from(
          widget.currentQuestion.options,
        ); // نسخ الخيارات الأصلية
        shuffledOptions.shuffle(Random()); // خلط الخيارات عشوائيًا
      });
    }

    // إذا تغيرت إجابة الطرف الآخر
    if (oldWidget.opponentAnswer != widget.opponentAnswer &&
        widget.opponentAnswer != null) {
      final index = shuffledOptions.indexOf(
        widget.opponentAnswer!, 
      ); // استخدام الخيارات المخلوطة لتحديد الخيار
      if (index != -1) {
        setState(() {
          opponentSelectedIndex = index;
          showAnswerFeedback = true;
        });
      }
    }
  }

  void playAnswerFeedbackSound(bool isCorrect) async {
    if (isCorrect) {
      await _audioPlayer.play(AssetSource('sounds/correct_answer.wav'));
    } else {
      await _audioPlayer.play(AssetSource('sounds/incorrect_answer.wav'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        shuffledOptions.length, // استخدام الخيارات المخلوطة
        (index) {
          final isCorrectAnswer =
              widget.currentQuestion.correctAnswer == shuffledOptions[index];
          final isSelected = selectedIndex == index;
          final isOpponentSelected = opponentSelectedIndex == index;

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

                      // تشغيل الصوت عند اختيار الإجابة
                      playAnswerFeedbackSound(isCorrectAnswer);

                      // تأخير لعرض التغذية الراجعة (Feedback)
                      await Future.delayed(const Duration(seconds: 1));

                      setState(() {
                        showAnswerFeedback = false;
                      });

                      widget.onSelectAnswer(
                        shuffledOptions[index], // استخدام الخيار المخلوط
                      );
                    }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected || isOpponentSelected
                        ? (isCorrectAnswer ? Colors.green : Colors.red)
                        : (widget.isPlayerTurn ? Colors.green : Colors.grey),
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  color: isSelected || isOpponentSelected
                      ? (isCorrectAnswer
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2))
                      : Colors.transparent,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8.0),
                    Text(shuffledOptions[index]), // استخدام الخيار المخلوط
                    const Spacer(),
                    if (showAnswerFeedback &&
                        (isSelected || isOpponentSelected))
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


// class QuestionOptionsWidget extends StatefulWidget {
//   const QuestionOptionsWidget({
//     super.key,
//     required this.currentQuestion,
//     required this.isPlayerTurn,
//     required this.onSelectAnswer,
//     this.opponentAnswer,
//   });

//   final QuestionModel currentQuestion;
//   final bool isPlayerTurn;
//   final Function(String answer) onSelectAnswer;
//   final String? opponentAnswer; // إجابة الطرف الآخر

//   @override
//   State<QuestionOptionsWidget> createState() => _QuestionOptionsWidgetState();
// }

// class _QuestionOptionsWidgetState extends State<QuestionOptionsWidget> {
//   int? selectedIndex;
//   bool showAnswerFeedback = false;
//   int? opponentSelectedIndex; // مؤشر الخيار الذي اختاره الطرف الآخر

//   List<String> shuffledOptions = []; // قائمة جديدة للخيارات المخلوطة

//   @override
//   void initState() {
//     super.initState();

//     shuffledOptions = List.from(
//       widget.currentQuestion.options,
//     ); // نسخ الخيارات الأصلية
//     shuffledOptions.shuffle(Random()); // خلط الخيارات عشوائيًا
//   }

//   @override
//   void didUpdateWidget(covariant QuestionOptionsWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     if (oldWidget.currentQuestion != widget.currentQuestion) {
//       // إعادة تعيين الحالة عند تغيير السؤال
//       setState(() {
//         selectedIndex = null;
//         opponentSelectedIndex = null;
//         showAnswerFeedback = false;
//         shuffledOptions = List.from(
//           widget.currentQuestion.options,
//         ); // نسخ الخيارات الأصلية
//         shuffledOptions.shuffle(Random()); // خلط الخيارات عشوائيًا
//       });
//     }

//     // إذا تغيرت إجابة الطرف الآخر
//     if (oldWidget.opponentAnswer != widget.opponentAnswer &&
//         widget.opponentAnswer != null) {
//       final index = shuffledOptions.indexOf(
//         widget.opponentAnswer!,
//       ); // استخدام الخيارات المخلوطة لتحديد الخيار
//       if (index != -1) {
//         setState(() {
//           opponentSelectedIndex = index;
//           showAnswerFeedback = true;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: List.generate(
//         shuffledOptions.length, // استخدام الخيارات المخلوطة
//         (index) {
//           final isCorrectAnswer =
//               widget.currentQuestion.correctAnswer == shuffledOptions[index];
//           final isSelected = selectedIndex == index;
//           final isOpponentSelected = opponentSelectedIndex == index;

//           return AnimatedOpacity(
//             duration: const Duration(milliseconds: 300),
//             opacity: widget.isPlayerTurn ? 1 : 0.5,
//             child: GestureDetector(
//               onTap: widget.isPlayerTurn
//                   ? () async {
//                       setState(() {
//                         selectedIndex = index;
//                         showAnswerFeedback = true;
//                       });

//                       // تأخير لعرض التغذية الراجعة (Feedback)
//                       await Future.delayed(const Duration(seconds: 1));

//                       setState(() {
//                         showAnswerFeedback = false;
//                       });

//                       widget.onSelectAnswer(
//                         shuffledOptions[index], // استخدام الخيار المخلوط
//                       );
//                     }
//                   : null,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 padding: const EdgeInsets.all(8.0),
//                 margin: const EdgeInsets.only(bottom: 8.0),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: isSelected || isOpponentSelected
//                         ? (isCorrectAnswer ? Colors.green : Colors.red)
//                         : (widget.isPlayerTurn ? Colors.green : Colors.grey),
//                   ),
//                   borderRadius: BorderRadius.circular(8.0),
//                   color: isSelected || isOpponentSelected
//                       ? (isCorrectAnswer
//                           ? Colors.green.withOpacity(0.2)
//                           : Colors.red.withOpacity(0.2))
//                       : Colors.transparent,
//                 ),
//                 child: Row(
//                   children: [
//                     const SizedBox(width: 8.0),
//                     Text(shuffledOptions[index]), // استخدام الخيار المخلوط
//                     const Spacer(),
//                     if (showAnswerFeedback &&
//                         (isSelected || isOpponentSelected))
//                       Icon(
//                         isCorrectAnswer ? Icons.check : Icons.close,
//                         color: isCorrectAnswer ? Colors.green : Colors.red,
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
