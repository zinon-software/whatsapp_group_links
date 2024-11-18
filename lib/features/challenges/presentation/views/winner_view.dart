import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../../../core/widgets/custom_button_widget.dart';
import '../../data/models/game_model.dart';
import '../cubit/challenges_cubit.dart';
import '../widgets/player_widget.dart';

class WinnerView extends StatelessWidget {
  const WinnerView({
    super.key,
    required this.game,
    required this.challengesCubit,
    required this.usersCubit,
  });

  final GameModel game;
  final ChallengesCubit challengesCubit;
  final UsersCubit usersCubit;

  @override
  Widget build(BuildContext context) {
    String winnerMessage;
    IconData winnerIcon;
    Color backgroundColor;

    if (game.myPlayer.score > game.otherPlayer.score) {
      // اللاعب الأول هو الفائز والمستخدم الحالي هو اللاعب الأول
      winnerMessage = "🎉 تهانينا! لقد فزت!";
      winnerIcon = Icons.emoji_events;
      backgroundColor = Colors.greenAccent.shade700;
    } else if (game.myPlayer.score < game.otherPlayer.score) {
      // المستخدم الحالي ليس الفائز (خسارة)
      winnerMessage = "😞 لم تفز هذه المرة. حاول مجدداً!";
      winnerIcon = Icons.sentiment_dissatisfied;
      backgroundColor = Colors.redAccent.shade100;
    } else {
      // تعادل بين اللاعبين والمستخدم الحالي أحدهم
      winnerMessage = "🤝 إنها تعادل!";
      winnerIcon = Icons.handshake;
      backgroundColor = Colors.blueAccent.shade700;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('نتيجة اللعبة'),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PlayerWidget(
                      isMe: true,
                      isHost: game.myPlayer.score >= game.otherPlayer.score,
                      isAi: false,
                      player: game.myPlayer,
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
                      isMe: false,
                      isHost: game.myPlayer.score <= game.otherPlayer.score,
                      isAi: game.isWithAi,
                      player: game.otherPlayer,
                      usersCubit: usersCubit,
                      gameId: game.id,
                    ),
                  ],
                ),
              ),
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
