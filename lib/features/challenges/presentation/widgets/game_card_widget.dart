import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/core/widgets/custom_cached_network_image_widget.dart';
import 'package:linkati/core/widgets/custom_skeletonizer_widget.dart';
import 'package:linkati/features/users/data/models/user_model.dart';

import '../../../users/presentation/cubit/users_cubit.dart';
import '../../data/models/game_model.dart';

class GameCardWidget extends StatelessWidget {
  const GameCardWidget({
    super.key,
    required this.game,
    required this.usersCubit,
  });
  final GameModel game;
  final UsersCubit usersCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PlayerWidget(player: game.player1, usersCubit: usersCubit),
            Expanded(
              child: Center(
                child: const Text(
                  'vs',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),

            if (game.player2?.userId != null)
              PlayerWidget(player: game.player2!, usersCubit: usersCubit)
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
                  CustomButtonWidget(
                    label: 'المشاركة',
                    enableClick: true,
                    enableBorder: true,
                    isLoading: false,
                    height: 30,
                    radius: 10,
                  ),
                ],
              ),

            // const SizedBox(height: 8),
            // // عرض معلومات إضافية للجلسة
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text('عدد الأسئلة: ${game.questionCount}'),
            //     Text('السؤال الحالي: ${game.currentQuestionNumber}'),
            //   ],
            // ),
            // const SizedBox(height: 8),
            // // حالة الدور الحالي
            // if (game.currentTurnPlayerId != null)
            //   Text(
            //     'الدور الحالي: ${game.currentTurnPlayerId}',
            //     style: TextStyle(fontWeight: FontWeight.bold),
            //   ),
          ],
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
  });
  final PlayerModel player;
  final UsersCubit usersCubit;

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  UserModel user = UserModel.isEmpty();

  @override
  void initState() {
    super.initState();

    widget.usersCubit.fetchPlayerUser(widget.player.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      bloc: widget.usersCubit,
      buildWhen: (previous, current) =>
          current is FetchPlayerUserLoadingState ||
          current is FetchPlayerUserErrorState ||
          current is FetchPlayerUserSuccessState,
      builder: (context, state) {
        if (state is FetchPlayerUserSuccessState) {
          user = state.user;
        }

        if (state is FetchPlayerUserErrorState) {
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
                onPressed: () =>
                    widget.usersCubit.fetchPlayerUser(widget.player.userId),
              ),
            ],
          );
        }

        if (state is FetchPlayerUserLoadingState) {
          return CustomSkeletonizerWidget(
            enabled: true,
            child: PlayerDataWidget(user: user),
          );
        }

        return PlayerDataWidget(user: user);
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
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.transparent,
          child: CustomCachedNetworkImage(
            user.photoUrl,
            borderRadius: 50,
          ),
        ),
        Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }
}
