


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/widgets/custom_button_widget.dart';
import '../../data/models/game_model.dart';
import '../cubit/challenges_cubit.dart';

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
    IconData winnerIcon;
    Color backgroundColor;

    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    if (game.player1.score > (game.player2?.score ?? 0) &&
        game.player1.userId == currentUserId) {
      // اللاعب الأول هو الفائز والمستخدم الحالي هو اللاعب الأول
      winnerMessage = "🎉 تهانينا! لقد فزت!";
      winnerIcon = Icons.emoji_events;
      backgroundColor = Colors.greenAccent.shade700;
    } else if (game.player2 != null &&
        game.player2!.score > game.player1.score &&
        game.player2!.userId == currentUserId) {
      // اللاعب الثاني هو الفائز والمستخدم الحالي هو اللاعب الثاني
      winnerMessage = "🎉 تهانينا! لقد فزت!";
      winnerIcon = Icons.emoji_events;
      backgroundColor = Colors.greenAccent.shade700;
    } else if ((game.player1.userId == currentUserId ||
            game.player2?.userId == currentUserId) &&
        game.player1.score == (game.player2?.score ?? 0)) {
      // تعادل بين اللاعبين والمستخدم الحالي أحدهم
      winnerMessage = "🤝 إنها تعادل!";
      winnerIcon = Icons.handshake;
      backgroundColor = Colors.blueAccent.shade700;
    } else {
      // المستخدم الحالي ليس الفائز (خسارة)
      winnerMessage = "😞 لم تفز هذه المرة. حاول مجدداً!";
      winnerIcon = Icons.sentiment_dissatisfied;
      backgroundColor = Colors.redAccent.shade100;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('النتيجة'),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: backgroundColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarColor: backgroundColor,
        ),
      ),
      body: Container(
        color: backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                winnerIcon,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Text(
                'نتيجة اللعبة',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                winnerMessage,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomButtonWidget(
                label: 'إغلاق',
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
      ),
    );
  }
}
