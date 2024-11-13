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
            current is FetchQuestionsLoadingState,
        listener: (context, state) {
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
        },
        child: StreamBuilder(
          stream: instance<AppCollections>()
              .games
              .where('topic', isEqualTo: widget.topic)
              .orderBy('started_at', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
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
                    session: session,
                    usersCubit: _usersCubit,
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
          // إضافة جلسة جديدة
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
