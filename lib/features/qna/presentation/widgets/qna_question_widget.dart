
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkati/core/extensions/date_format_extension.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../users/presentation/widgets/user_widget.dart';
import '../../data/models/qna_question_model.dart';

class QnaQuestionWidget extends StatelessWidget {
  const QnaQuestionWidget({
    super.key,
    required this.qnaQuestion,
    required this.showUser,
  });

  final QnaQuestionModel qnaQuestion;
  final bool showUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.qnaDetailsRoute,
            arguments: {'question': qnaQuestion},
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showUser)
              Row(
                children: [
                  Expanded(
                    child: LoadUserWidget(
                      userId: qnaQuestion.authorId,
                      query: qnaQuestion.id,
                    ),
                  ),

                  // date
                  Text(qnaQuestion.createdAt.formatTimeAgoString()),
                ],
              ),
            if (showUser) Divider(),
            Text(
              qnaQuestion.text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (qnaQuestion.category != null)
                  Chip(
                    label: Text(
                      qnaQuestion.category!,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    "عدد الاجابات ${qnaQuestion.answersCount}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Spacer(),
                if (FirebaseAuth.instance.currentUser?.uid ==
                    qnaQuestion.authorId)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.qnaFormRoute,
                        arguments: {'question': qnaQuestion},
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
