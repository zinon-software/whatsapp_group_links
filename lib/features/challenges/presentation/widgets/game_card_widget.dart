import 'package:flutter/material.dart';
import 'package:linkati/core/routes/app_routes.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/features/challenges/data/models/question_model.dart';
import 'package:linkati/features/challenges/presentation/cubit/challenges_cubit.dart';

import '../../../users/presentation/cubit/users_cubit.dart';
import '../../data/models/game_model.dart';
import 'player_widget.dart';

class GameCardWidget extends StatelessWidget {
  const GameCardWidget({
    super.key,
    required this.game,
    required this.usersCubit,
    required this.challengesCubit,
    required this.questions,
  });
  final GameModel game;
  final UsersCubit usersCubit;
  final ChallengesCubit challengesCubit;
  final List<QuestionModel> questions;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: usersCubit.currentUser?.id == game.player1.userId
          ? () {
              Navigator.pushNamed(
                context,
                AppRoutes.waitingForPlayerRoute,
                arguments: {
                  'game': game,
                  'questions': questions,
                },
              );
            }
          : usersCubit.currentUser?.id == game.player2?.userId
              ? () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.gameRoute,
                    arguments: {
                      'game': game,
                      "questions": questions,
                    },
                  );
                }
              : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        width: double.infinity,
        height: 220,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PlayerWidget(
                isMe: game.player1.userId == usersCubit.currentUser!.id,
                isAi: false,
                isHost: game.currentTurnPlayerId == game.player1.userId,
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
              if (game.player2?.userId != null)
                PlayerWidget(
                  isMe: game.player2!.userId == usersCubit.currentUser!.id,
                  isAi: game.isWithAi,
                  isHost: game.currentTurnPlayerId == game.player2!.userId,
                  player: game.player2!,
                  usersCubit: usersCubit,
                  gameId: game.id,
                )
              else
                Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const Text(
                      'لا يوجد لاعب',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    if (game.player1.userId != usersCubit.currentUser!.id)
                      CustomButtonWidget(
                        label: 'المشاركة',
                        height: 30,
                        radius: 10,
                        onPressed: () {
                          challengesCubit.joinGameEvent(
                            game.copyWith(
                              player2: PlayerModel(
                                userId: usersCubit.currentUser!.id,
                                score: 0,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
