import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/features/qna/presentation/cubit/qna_cubit.dart';

import '../../../../core/routes/app_routes.dart';

class QnasScreen extends StatelessWidget {
  const QnasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QnaCubit qnaCubit = context.read<QnaCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('تساؤلات'),
        centerTitle: true,
      ),
      body: BlocBuilder<QnaCubit, QnaState>(
        bloc: qnaCubit,
        buildWhen: (previous, current) =>
            current is QnaQuestionsSuccessState ||
            current is QnaQuestionsErrorState ||
            current is QnaQuestionsLoadingState,
        builder: (context, state) {
          if (state is QnaQuestionsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QnaQuestionsErrorState) {
            return Center(child: Text(state.message));
          } else if (state is QnaQuestionsSuccessState) {
            if (state.questions.isEmpty) {
              return const Center(child: Text('لا يوجد اسئلة'));
            }

            return ListView.builder(
              itemCount: state.questions.length,
              itemBuilder: (context, index) {
                final qnaQuestion = state.questions[index];
                return ListTile(
                  title: Text(qnaQuestion.text),
                  subtitle: Text(qnaQuestion.category ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.qnaFormRoute,
                        arguments: {'question': qnaQuestion},
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            Navigator.of(context).pushNamed(AppRoutes.qnaFormRoute),
      ),
    );
  }
}
