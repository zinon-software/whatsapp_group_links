import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_button_widget.dart';
import '../../../../core/widgets/custom_cached_network_image_widget.dart';
import '../../../../core/widgets/custom_skeletonizer_widget.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/presentation/cubit/users_cubit.dart';
import '../../data/models/game_model.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({
    super.key,
    required this.player,
    required this.usersCubit,
    required this.gameId,
    this.isHost = false,
    this.isMe = false,
  });
  final PlayerModel player;
  final UsersCubit usersCubit;
  final String gameId;
  final bool isHost;
  final bool isMe;

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  UserModel? user;

  @override
  void initState() {
    super.initState();

    if (widget.player.user == null) {
      widget.usersCubit.fetchPlayerUserEvent(
        userId: widget.player.userId,
        gameId: widget.gameId,
      );
    } else {
      user = widget.player.user;
    }
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
          return PlayerDataWidget(
            user: state.user,
            isHost: widget.isHost,
            isMe: widget.isMe,
            score: widget.player.score,
          );
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
            child: PlayerDataWidget(
              user: UserModel.isEmpty(),
              isHost: false,
              isMe: false,
              score: 0,
            ),
          );
        }

        // إذا لم يتم تلبية أي من الحالات أعلاه، يعرض عنصر فارغ افتراضي
        return PlayerDataWidget(
          user: user ?? UserModel.isEmpty(),
          isHost: widget.isHost,
          isMe: widget.isMe,
          score: widget.player.score,
        );
      },
    );
  }
}

class PlayerDataWidget extends StatelessWidget {
  const PlayerDataWidget({
    super.key,
    required this.user,
    required this.isHost,
    required this.isMe,
    this.score = 0,
  });

  final UserModel user;
  final bool isHost;
  final bool isMe;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue[50] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: isHost ? Colors.amber : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                child: CustomCachedNetworkImage(
                  user.photoUrl,
                  borderRadius: 50,
                ),
              ),
              if (isHost)
                const Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 24,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isMe ? 'أنت' : user.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.monetization_on,
                color: Colors.green,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                '$score',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
