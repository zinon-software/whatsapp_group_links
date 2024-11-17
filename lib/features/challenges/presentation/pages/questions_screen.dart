import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/features/challenges/presentation/cubit/challenges_cubit.dart';

import '../../../../core/routes/app_routes.dart';
import '../../data/models/question_model.dart';
import '../../data/models/topic_model.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key, required this.topic});
  final TopicModel topic;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  late final ChallengesCubit _challengesCubit;

  @override
  void initState() {
    _challengesCubit = context.read<ChallengesCubit>();
    super.initState();
    _challengesCubit.fetchQuestionsEvent(widget.topic.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
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
                  leading: Text('${index + 1}'),
                  title: Text(question.question),
                  subtitle: Wrap(
                    spacing: 8,
                    runSpacing: 8,
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
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.questionFormRoute,
                        arguments: {
                          'question': question,
                          'topic': widget.topic.id
                        },
                      ).then((value) => _challengesCubit
                          .fetchQuestionsEvent(widget.topic.id));
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_question${widget.topic.id}',
        onPressed: () async {
          Navigator.of(context).pushNamed(
            AppRoutes.questionFormRoute,
            arguments: {'topic': widget.topic.id},
          ).then(
            (value) => _challengesCubit.fetchQuestionsEvent(widget.topic.id),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
