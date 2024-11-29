import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/core/api/app_collections.dart';
import 'package:linkati/core/storage/storage_repository.dart';
import 'package:linkati/core/widgets/custom_text_field.dart';
import 'package:linkati/features/qna/presentation/cubit/qna_cubit.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/alert_widget.dart';
import '../../../../core/widgets/notification_bell_widget.dart';
import '../../../users/data/models/user_model.dart';
import '../../data/models/qna_answer_model.dart';
import '../../data/models/qna_question_model.dart';
import '../widgets/qna_answer_widget.dart';
import '../widgets/qna_question_widget.dart';

class QnaDetailsScreen extends StatefulWidget {
  const QnaDetailsScreen({super.key, this.question, required this.questionId});
  final QnaQuestionModel? question;
  final String questionId;

  @override
  State<QnaDetailsScreen> createState() => _QnaDetailsScreenState();
}

class _QnaDetailsScreenState extends State<QnaDetailsScreen> {
  late final TextEditingController _answerController;
  late final QnaCubit _qnaCubit;
  late QnaQuestionModel question;

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController();
    _qnaCubit = context.read<QnaCubit>();
    _initQuestion();
  }

  void _initQuestion() {
    if (widget.question != null) {
      question = widget.question!;
    } else {
      try {
        question = _qnaCubit.qnaQuestions.firstWhere(
          (element) => element.id == widget.questionId,
        );
      } catch (e) {
        question = QnaQuestionModel.empty().copyWith(id: widget.questionId);
        _qnaCubit.fetchQnaQuestionEvent(widget.questionId);
      }
    }
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
      questionId: question.id,
      authorId: FirebaseAuth.instance.currentUser!.uid,
      text: _answerController.text.trim(),
      votes: 0,
      createdAt: DateTime.now(),
    );

    _qnaCubit.createAnswerEvent(newAnswer);
    _answerController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(question.text, style: const TextStyle(fontSize: 18)),
        actions: [
          NotificationBellWidget(topic: question.id),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // قسم السؤال
                SliverToBoxAdapter(
                  child: BlocBuilder<QnaCubit, QnaState>(
                    bloc: _qnaCubit,
                    buildWhen: (previous, current) =>
                        current is QnaQuestionSuccessState,
                    builder: (context, state) {
                      question = state is QnaQuestionSuccessState
                          ? state.question
                          : question;
                      return QnaQuestionWidget(
                        qnaQuestion: question,
                        canTap: false,
                        hasShadow: false,
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
                // قائمة الإجابات
                StreamBuilder<QuerySnapshot>(
                  stream: instance<AppCollections>()
                      .qnaAnswers
                      .where('question_id', isEqualTo: question.id)
                      .orderBy('created_at', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()));
                    }
                    if (snapshot.hasError) {
                      return const SliverToBoxAdapter(
                          child: Center(
                              child: Text('حدث خطأ أثناء تحميل الإجابات')));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const SliverToBoxAdapter(
                          child: Center(child: Text('لا توجد إجابات بعد')));
                    }

                    final answers = snapshot.data!.docs.map((doc) {
                      return QnaAnswerModel.fromJson(
                        doc.data() as Map<String, dynamic>,
                      );
                    }).toList();

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final answer = answers[index];
                          return QnaAnswerWidget(
                            answer: answer,
                            qnaCubit: _qnaCubit,
                            user: instance<StorageRepository>().getData(
                                  key: answer.authorId,
                                ) as UserModel? ??
                                UserModel.empty(),
                          );
                        },
                        childCount: answers.length,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // حقل إدخال
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            height: null,
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _answerController,
                    hintText: 'اكتب إجابتك...',
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14),
                    child: const Icon(
                      CupertinoIcons.paperplane,
                      color: Colors.blue,
                    ),
                  ),
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
                          );
                        },
                      );
                    } else {
                      _submitAnswer();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
