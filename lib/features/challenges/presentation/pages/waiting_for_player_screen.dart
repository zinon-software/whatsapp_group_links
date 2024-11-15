import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/features/challenges/data/models/game_model.dart';
import 'package:linkati/features/challenges/presentation/cubit/challenges_cubit.dart';

import '../../../../core/api/app_collections.dart';
import '../../../../core/routes/app_routes.dart';
import '../../data/models/question_model.dart';

class WaitingForPlayerScreen extends StatefulWidget {
  final GameModel game;
  final List<QuestionModel> questions;

  const WaitingForPlayerScreen({
    super.key,
    required this.game,
    required this.questions,
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
        body: BlocListener<ChallengesCubit, ChallengesState>(
          bloc: _challengesCubit,
          listener: _onListener,
          child: StreamBuilder(
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
              if (snapshot.data!.data() != null) {
                game = GameModel.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>,
                );
              }
              if (game.player2 != null) {
                _challengesCubit.goToGameEvent(
                  game.copyWith(startedAt: DateTime.now()),
                );

                return Center(
                  child: Text(
                    'تم انضمام اللاعب الآخر: }',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return WaitingContentWidget(
                game: game,
                challengesCubit: _challengesCubit,
              );
            },
          ),
        ),
      ),
    );
  }

  void _onListener(context, state) {
    if (state is GoToGameState) {
      Navigator.of(context).pushNamed(
        AppRoutes.gameRoute,
        arguments: {'game': state.game, "questions": widget.questions},
      ).then((value) {
        Navigator.of(context).pop();
      });
    }
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await AppAlert.showAlert(
      context,
      title: 'تأكيد الخروج',
      subTitle: 'هل تريد الخروج من اللعبة؟',
      confirmText: 'نعم، خروج',
      dismissOn: false,
      onConfirm: () {
        _challengesCubit.endGameEvent(widget.game);
        Navigator.of(context).pop(true);
      },
      cancelText: 'اغلاق',
      onCancel: () => Navigator.of(context).pop(false),
    );
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
          const SizedBox(height: 40),
          CustomButtonWidget(
            label: 'العب ضد الذكاء الاصطناعي',
            radius: 10,
            height: 50,
            width: 250,
            onPressed: () {
              challengesCubit.startGameWithAiEvent(game);
            },
          ),
          const SizedBox(height: 20),
          CustomButtonWidget(
            label: 'إلغاء اللعبة',
            radius: 10,
            height: 50,
            width: 250,
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
