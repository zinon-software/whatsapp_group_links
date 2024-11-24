import 'package:flutter/material.dart';

import '../../data/models/qna_question_model.dart';

class QnaDetailsScreen extends StatelessWidget {
  const QnaDetailsScreen({super.key, required this.question});
  final QnaQuestionModel question;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاسئلة الشائعة'),
        centerTitle: true,
      ),
      body: Center(child: Text(question.text)),
    );
  }
}
