import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/features/qna/presentation/cubit/qna_cubit.dart';

import '../../../../core/routes/app_routes.dart';
import '../widgets/qna_question_widget.dart';

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
              return const Center(child: Text('لا يوجد أسئلة'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: state.questions.length,
              itemBuilder: (context, index) {
                final qnaQuestion = state.questions[index];
                return QnaQuestionWidget(
                  qnaQuestion: qnaQuestion,
                  showUser: true,
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
        onPressed: () {
          if (FirebaseAuth.instance.currentUser != null) {
            Navigator.of(context).pushNamed(AppRoutes.qnaFormRoute);
          } else {
            AppAlert.showAlert(
              context,
              subTitle: "يرجى تسجيل الدخول",
              confirmText: "تسجيل الدخول",
              onConfirm: () {
                AppAlert.dismissDialog(context);
                Navigator.of(context).pushNamed(
                  AppRoutes.loginRoute,
                  arguments: {
                    "return_route": true,
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
