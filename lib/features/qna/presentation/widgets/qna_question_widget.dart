import 'package:flutter/material.dart';
import 'package:linkati/core/extensions/date_format_extension.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../../../config/app_injector.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../users/presentation/widgets/user_widget.dart';
import '../../data/models/qna_question_model.dart';

class QnaQuestionWidget extends StatelessWidget {
  const QnaQuestionWidget({
    super.key,
    required this.qnaQuestion,
    required this.canTap,
    this.hasShadow = true,
  });

  final QnaQuestionModel qnaQuestion;
  final bool canTap;
  final bool hasShadow;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'qnaQuestionCard-${qnaQuestion.id}', // مفتاح Hero فريد لكل بطاقة
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: hasShadow
                ? const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: canTap
                ? () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.qnaDetailsRoute,
                      arguments: {
                        'question': qnaQuestion,
                        'question_id': qnaQuestion.id,
                      },
                    );
                  }
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Divider(),
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
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 0,
                      ),
                      label: Text(
                        "${qnaQuestion.answersCount} رداً",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Spacer(),
                    if (instance<UsersCubit>().currentUser?.id ==
                            qnaQuestion.authorId ||
                        (instance<UsersCubit>().currentUser?.isAdmin ?? false))
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
        ),
      ),
    );
  }
}
