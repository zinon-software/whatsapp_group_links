import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/features/challenges/data/models/game_model.dart';
import 'package:linkati/features/challenges/presentation/cubit/challenges_cubit.dart';

import '../../../../core/api/app_collections.dart';

class WaitingForPlayerScreen extends StatefulWidget {
  final GameModel game;

  const WaitingForPlayerScreen({
    super.key,
    required this.game,
  });

  @override
  State<WaitingForPlayerScreen> createState() => _WaitingForPlayerScreenState();
}

class _WaitingForPlayerScreenState extends State<WaitingForPlayerScreen> {
  late GameModel game;
  late ChallengesCubit _challengesCubit;

  @override
  void initState() {
    game = widget.game;
    _challengesCubit = context.read<ChallengesCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('انتظار انضمام لاعب آخر'),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: instance<AppCollections>().games.doc(game.id).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return WaitingContentWidget(
                game: game,
                challengesCubit: _challengesCubit,
              );
            }
            game = GameModel.fromJson(
              snapshot.data!.data() as Map<String, dynamic>,
            );
            return WaitingContentWidget(
              game: game,
              challengesCubit: _challengesCubit,
            );
          },
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('تأكيد الخروج'),
            content:
                const Text('هل أنت متأكد أنك تريد الخروج؟ سيتم إلغاء اللعبة.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  _challengesCubit.endGameEvent(widget.game);
                  Navigator.of(context).pop(true);
                },
                child: const Text('نعم، خروج'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class WaitingContentWidget extends StatelessWidget {
  final GameModel game;
  final ChallengesCubit challengesCubit;

  const WaitingContentWidget({
    super.key,
    required this.game,
    required this.challengesCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'في انتظار انضمام لاعب آخر...',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          CustomButtonWidget(
            label: 'العب ضد البوت',
            radius: 10,
            height: 50,
            width: 200,
            onPressed: () {
              challengesCubit.startGameWithAiEvent(game);
            },
          ),
          const SizedBox(height: 20),
          CustomButtonWidget(
            label: 'إلغاء اللعبة',
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
    );
  }
}
