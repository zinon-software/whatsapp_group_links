import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkati/core/extensions/date_format_extension.dart';
import 'package:linkati/core/utils/color_manager.dart';
import 'package:linkati/core/widgets/custom_cached_network_image_widget.dart';

import '../../../../config/app_injector.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/storage/storage_repository.dart';
import '../../../../core/widgets/alert_widget.dart';
import '../../../users/data/models/user_model.dart';
import '../../data/models/qna_answer_model.dart';
import '../cubit/qna_cubit.dart'; // لاستخدام Timer

class QnaAnswerWidget extends StatefulWidget {
  const QnaAnswerWidget({
    super.key,
    required this.answer,
    required this.qnaCubit,
    required this.user,
  });

  final QnaAnswerModel answer;
  final QnaCubit qnaCubit;
  final UserModel user;

  @override
  State<QnaAnswerWidget> createState() => _QnaAnswerWidgetState();
}

class _QnaAnswerWidgetState extends State<QnaAnswerWidget> {
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
        widget.qnaCubit.incrementAnswerVotesEvent(widget.answer);
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
    late final bool isCurrentUser =
        widget.answer.authorId == FirebaseAuth.instance.currentUser?.uid;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: CustomCachedNetworkImage(
            widget.user.photoUrl,
          ).imageProvider,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                elevation: 2,
                color: ColorsManager.fillColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      // نص الإجابة
                      Text(
                        widget.answer.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(widget.answer.text),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    widget.answer.createdAt.formatTimeAgoString(),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: toggleLike,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Row(
                        children: [
                          Icon(
                            isLiked
                                ? Icons.thumb_up
                                : Icons.thumb_up_alt_outlined,
                            key: ValueKey(isLiked),
                            color: isLiked ? Colors.green : Colors.grey,
                            size: isAnimating ? 26 : 24, // تأثير الحجم
                          ),
                          SizedBox(width: 4),
                          Text("${widget.answer.votes}"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (isCurrentUser)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        widget.qnaCubit.deleteAnswerEvent(widget.answer.id);
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
