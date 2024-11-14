import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/core/widgets/custom_cached_network_image_widget.dart';
import 'package:linkati/core/widgets/custom_skeletonizer_widget.dart';
import 'package:linkati/features/challenges/presentation/cubit/challenges_cubit.dart';
import 'package:linkati/features/users/data/models/user_model.dart';

import '../../../users/presentation/cubit/users_cubit.dart';
import '../../data/models/game_model.dart';

class GameCardWidget extends StatelessWidget {
  const GameCardWidget({
    super.key,
    required this.game,
    required this.usersCubit,
    required this.challengesCubit,
  });
  final GameModel game;
  final UsersCubit usersCubit;
  final ChallengesCubit challengesCubit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: usersCubit.currentUser?.id == game.player1.userId
          ? () {
              challengesCubit.endGameEvent(game);
            }
          : usersCubit.currentUser?.id == game.player2?.userId
              ? () {}
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
        height: 185,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PlayerWidget(
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

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({
    super.key,
    required this.player,
    required this.usersCubit,
    required this.gameId,
  });
  final PlayerModel player;
  final UsersCubit usersCubit;
  final String gameId;

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  UserModel? user;

  @override
  void initState() {
    super.initState();

    widget.usersCubit.fetchPlayerUserEvent(
      userId: widget.player.userId,
      gameId: widget.gameId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      bloc: widget.usersCubit,
      buildWhen: (previous, current) {
        if (current is FetchPlayerUserSuccessState) {
          return current.gameId == widget.gameId &&
              current.user.id == widget.player.userId;
        }
        if (current is FetchPlayerUserErrorState) {
          return current.gameId == widget.gameId &&
              current.userId == widget.player.userId;
        }
        if (current is FetchPlayerUserLoadingState) {
          return current.gameId == widget.gameId &&
              current.userId == widget.player.userId;
        }
        return false;
      },
      builder: (context, state) {
        if (state is FetchPlayerUserSuccessState &&
            state.user.id == widget.player.userId &&
            state.gameId == widget.gameId) {
          user = state.user;
          widget.player.user = state.user;
          return PlayerDataWidget(user: state.user);
        }

        if (state is FetchPlayerUserErrorState &&
            state.userId == widget.player.userId &&
            state.gameId == widget.gameId) {
          return Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const Text('خطأ في جلب البيانات'),
              CustomButtonWidget(
                label: 'اعادة المحاولة',
                enableClick: true,
                enableBorder: true,
                isLoading: false,
                height: 30,
                radius: 10,
                onPressed: () => widget.usersCubit.fetchPlayerUserEvent(
                  userId: widget.player.userId,
                  gameId: widget.gameId,
                ),
              ),
            ],
          );
        }

        if (state is FetchPlayerUserLoadingState &&
            state.userId == widget.player.userId &&
            state.gameId == widget.gameId) {
          // عرض Skeleton عندما تكون البيانات قيد التحميل
          return CustomSkeletonizerWidget(
            enabled: true,
            child: PlayerDataWidget(user: UserModel.isEmpty()),
          );
        }

        // إذا لم يتم تلبية أي من الحالات أعلاه، يعرض عنصر فارغ افتراضي
        return PlayerDataWidget(user: user ?? UserModel.isEmpty());
      },
    );
  }
}

class PlayerDataWidget extends StatelessWidget {
  const PlayerDataWidget({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.transparent,
            child: CustomCachedNetworkImage(
              user.photoUrl,
              borderRadius: 50,
            ),
          ),
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // add imoge of coins
              const Icon(
                Icons.monetization_on,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              Text('${user.score}'),
            ],
          ),
        ],
      ),
    );
  }
}
