import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkati/core/extensions/date_format_extension.dart';

import '../../../../config/app_injector.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/storage/storage_repository.dart';
import '../../../../core/widgets/alert_widget.dart';
import '../../../users/presentation/widgets/user_widget.dart';
import '../../data/models/qna_answer_model.dart';
import '../cubit/qna_cubit.dart'; // لاستخدام Timer

class QnaAnswerWidget extends StatefulWidget {
  const QnaAnswerWidget({
    super.key,
    required this.answer,
    required this.qnaCubit,
  });

  final QnaAnswerModel answer;
  final QnaCubit qnaCubit;

  @override
  State<QnaAnswerWidget> createState() => _QnaAnswerWidgetState();
}

class _QnaAnswerWidgetState extends State<QnaAnswerWidget> {
  late final bool isCurrentUser =
      widget.answer.authorId == FirebaseAuth.instance.currentUser?.uid;
  bool isLiked = false;
  bool isAnimating = false; // للتحكم في حالة التفاعل
  final StorageRepository storageRepository = instance<StorageRepository>();

  @override
  void initState() {
    super.initState();
    isLiked = storageRepository.containsKey(widget.answer.id);
  }

  void toggleLike() {
    if (FirebaseAuth.instance.currentUser == null) {
      AppAlert.showAlert(
        context,
        subTitle: "يرجى تسجيل الدخول",
        confirmText: "تسجيل الدخول",
        onConfirm: () {
          AppAlert.dismissDialog(context);
          Navigator.of(context).pushNamed(
            AppRoutes.loginRoute,
            arguments: {"return_route": true},
          );
        },
      );
    } else {
      setState(() {
        isLiked = !isLiked;
        isAnimating = true; // تفعيل الرسوم المتحركة
      });

      // التحكم في الحفظ والإزالة
      if (isLiked) {
        storageRepository.setData(key: widget.answer.id, value: true);
        widget.qnaCubit.incrementAnswerVotesEvent(widget.answer.id);
      } else {
        storageRepository.deleteData(key: widget.answer.id);
        widget.qnaCubit.decrementAnswerVotesEvent(widget.answer.id);
      }

      // إعادة تعيين حالة الرسوم المتحركة بعد انتهاء الرسوم
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          isAnimating = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      color: isCurrentUser ? null : Colors.blue.shade50,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: LoadUserWidget(
                    userId: widget.answer.authorId,
                    query: widget.answer.id,
                  ),
                ),
                Text("${widget.answer.votes}"),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: toggleLike,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                      key: ValueKey(isLiked),
                      color: isLiked ? Colors.green : Colors.grey,
                      size: isAnimating ? 36 : 24, // تأثير الحجم
                    ),
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
          ),
          ListTile(
            title: Text(widget.answer.text),
            subtitle: Text(widget.answer.createdAt.formatTimeAgoString()),
          ),
        ],
      ),
    );
  }
}
