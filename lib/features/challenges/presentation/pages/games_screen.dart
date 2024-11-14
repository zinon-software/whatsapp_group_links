import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/features/challenges/data/models/question_model.dart';
import 'package:linkati/features/challenges/presentation/cubit/challenges_cubit.dart';

import '../../../../config/app_injector.dart';
import '../../../../core/api/app_collections.dart';
import '../../../users/presentation/cubit/users_cubit.dart';
import '../../data/models/game_model.dart';
import '../widgets/game_card_widget.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key, required this.topic});
  final String topic;

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  late final UsersCubit _usersCubit;
  late final ChallengesCubit _challengesCubit;

  List<QuestionModel> questions = [];

  @override
  void initState() {
    _usersCubit = context.read<UsersCubit>();
    _challengesCubit = context.read<ChallengesCubit>();

    super.initState();

    _challengesCubit.fetchQuestionsEvent(widget.topic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المبارزات'),
      ),
      body: BlocListener<ChallengesCubit, ChallengesState>(
        bloc: _challengesCubit,
        listenWhen: (previous, current) =>
            current is FetchQuestionsSuccessState ||
            current is FetchQuestionsErrorState ||
            current is FetchQuestionsLoadingState ||
            current is ManageGameLoadingState ||
            current is ManageGameErrorState ||
            current is ManageGameSuccessState,
        listener: _onListener,
        child: StreamBuilder(
          stream: instance<AppCollections>()
              .games
              .where('topic', isEqualTo: widget.topic)
              .where('ended_at', isNull: true)
              .orderBy('started_at', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('خطأ: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('لا يوجد روابط'),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  GameModel session = GameModel.fromJson(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>,
                  );
                  session = session.copyWith(questions: questions);
                  return GameCardWidget(
                    game: session,
                    usersCubit: _usersCubit,
                    challengesCubit: _challengesCubit,
                  );
                },
              );
            }
            return const Center(
              child: Text('لا توجد بيانات'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _challengesCubit.createGameEvent(
            GameModel(
              id: '',
              player1: PlayerModel(
                userId: _usersCubit.currentUser!.id,
                score: _usersCubit.currentUser!.score,
              ),
              topic: widget.topic,
              currentTurnPlayerId: _usersCubit.currentUser!.id,
              currntQuestionId: '',
              questions: questions,
              currentQuestionNumber: 0,
              startedAt: DateTime.now(),
              duration: const Duration(minutes: 30),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onListener(context, state) {
    if (state is ManageGameLoadingState) {
      AppAlert.loading(context);
    }
    if (state is ManageGameErrorState) {
      AppAlert.showAlert(context, subTitle: state.failure);
    }
    if (state is ManageGameSuccessState) {
      AppAlert.dismissDialog(context);
      if (state.isJoined) {
        AppAlert.showAlert(context, subTitle: 'تم الانضمام للمباراة بنجاح');
      } else {
        AppAlert.showAlert(context, subTitle: 'تم الانضمام للمباراة بنجاح');
      }
    }
    if (state is FetchQuestionsSuccessState) {
      AppAlert.dismissDialog(context);
      questions = state.questions;
    }
    if (state is FetchQuestionsErrorState) {
      AppAlert.showAlert(context, subTitle: state.failure);
    }
    if (state is FetchQuestionsLoadingState) {
      AppAlert.loading(context);
    }
  }
}
