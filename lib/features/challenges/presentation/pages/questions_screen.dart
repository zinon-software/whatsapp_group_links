import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/features/challenges/presentation/cubit/challenges_cubit.dart';

import '../../../../core/routes/app_routes.dart';
import '../../data/models/question_model.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key, required this.topic});
  final String topic;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  late final ChallengesCubit _challengesCubit;

  @override
  void initState() {
    _challengesCubit = context.read<ChallengesCubit>();
    super.initState();
    _challengesCubit.fetchQuestionsEvent(widget.topic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic),
      ),
      body: BlocBuilder<ChallengesCubit, ChallengesState>(
        bloc: _challengesCubit,
        buildWhen: (previous, current) =>
            current is FetchQuestionsSuccessState ||
            current is FetchQuestionsErrorState ||
            current is FetchQuestionsLoadingState,
        builder: (context, state) {
          if (state is FetchQuestionsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FetchQuestionsErrorState) {
            return Center(child: Text(state.failure));
          }
          if (state is FetchQuestionsSuccessState) {
            return ListView.builder(
              itemCount: state.questions.length,
              itemBuilder: (context, index) {
                final QuestionModel question = state.questions[index];
                return ListTile(
                  title: Text(question.question),
                  subtitle: Wrap(
                    spacing: 8,
                    children: question.options
                        .map(
                          (e) => Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: question.correctAnswer == e
                                  ? Colors.green
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              e,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: question.correctAnswer == e
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            AppRoutes.questionFormRoute,
            arguments: {'topic': widget.topic},
          ).then(
            (value) => _challengesCubit.fetchQuestionsEvent(widget.topic),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
