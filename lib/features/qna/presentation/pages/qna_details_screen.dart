import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/core/api/app_collections.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/core/widgets/custom_text_field.dart';
import 'package:linkati/features/qna/presentation/cubit/qna_cubit.dart';
import 'package:linkati/features/users/presentation/widgets/user_widget.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/alert_widget.dart';
import '../../data/models/qna_answer_model.dart';
import '../../data/models/qna_question_model.dart';
import '../widgets/qna_answer_widget.dart';
import '../widgets/qna_question_widget.dart';

class QnaDetailsScreen extends StatefulWidget {
  const QnaDetailsScreen({super.key, required this.question});
  final QnaQuestionModel question;

  @override
  State<QnaDetailsScreen> createState() => _QnaDetailsScreenState();
}

class _QnaDetailsScreenState extends State<QnaDetailsScreen> {
  late final TextEditingController _answerController;
  late final QnaCubit _qnaCubit;

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController();
    _qnaCubit = context.read<QnaCubit>();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _submitAnswer() async {
    if (_answerController.text.trim().isEmpty) return;

    final newAnswer = QnaAnswerModel(
      id: '',
      questionId: widget.question.id,
      authorId: FirebaseAuth.instance.currentUser!.uid,
      text: _answerController.text.trim(),
      votes: 0,
      createdAt: DateTime.now(),
    );

    _qnaCubit.createAnswerEvent(newAnswer, widget.question.authorId);
    _answerController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LoadUserWidget(
          userId: widget.question.authorId,
          query: widget.question.id,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          QnaQuestionWidget(
            qnaQuestion: widget.question,
            showUser: false,
          ),
          // قائمة الإجابات
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: instance<AppCollections>()
                  .qnaAnswers
                  .where('question_id', isEqualTo: widget.question.id)
                  .orderBy('created_at', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                      child: Text('حدث خطأ أثناء تحميل الإجابات'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('لا توجد إجابات بعد'));
                }

                final answers = snapshot.data!.docs.map(
                  (doc) {
                    return QnaAnswerModel.fromJson(
                      doc.data() as Map<String, dynamic>,
                    );
                  },
                ).toList();

                return ListView.builder(
                  itemCount: answers.length,
                  itemBuilder: (context, index) {
                    final answer = answers[index];
                    return QnaAnswerWidget(
                      answer: answer,
                      qnaCubit: _qnaCubit,
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          // حقل إدخال لإضافة إجابة جديدة
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 16),
            child: BlocBuilder<QnaCubit, QnaState>(
              bloc: _qnaCubit,
              builder: (context, state) {
                return Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _answerController,
                        hintText: 'أضف إجابتك هنا...',
                        readOnly: state is ManageAnswerLoadingState,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CustomButtonWidget(
                      width: 50,
                      height: 60,
                      onPressed: () {
                        if (FirebaseAuth.instance.currentUser == null) {
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
                        } else {
                          _submitAnswer();
                        }
                      },
                      icon: Icons.send,
                      isLoading: state is ManageAnswerLoadingState,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
