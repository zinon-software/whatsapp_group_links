import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkati/core/extensions/date_format_extension.dart';
import 'package:linkati/core/utils/color_manager.dart';
import 'package:linkati/core/widgets/custom_cached_network_image_widget.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../../../config/app_injector.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/storage/storage_repository.dart';
import '../../../../core/widgets/alert_widget.dart';
import '../../../../core/widgets/custom_text_field.dart';
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
      });

      // التحكم في الحفظ والإزالة
      if (isLiked) {
        storageRepository.setData(key: widget.answer.id, value: true);
        widget.qnaCubit.incrementAnswerVotesEvent(widget.answer);
      } else {
        storageRepository.deleteData(key: widget.answer.id);
        widget.qnaCubit.decrementAnswerVotesEvent(widget.answer.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    late final bool isCurrentUser =
        widget.answer.authorId == instance<UsersCubit>().currentUser?.id ||
            instance<UsersCubit>().currentUser?.permissions.isAdmin == true;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: CustomCachedNetworkImage(
                  widget.user.photoUrl,
                ).imageProvider,
              ),
              const SizedBox(height: 5),
              if (isCurrentUser)
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                    AppAlert.showAlert(
                      context,
                      subTitle: "هل تريد حذف الرد؟",
                      confirmText: "حذف",
                      onConfirm: () {
                        widget.qnaCubit.deleteAnswerEvent(widget.answer.id);
                      },
                    );
                  },
                  iconSize: 20,
                ),
            ],
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  elevation: 0,
                  color: ColorsManager.fillColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.name,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.answer.text,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      widget.answer.createdAt.timeAgo(),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: toggleLike,
                      child: Row(
                        children: [
                          Text(
                            "أعجبني",
                            style: TextStyle(
                              fontSize: 12,
                              color: isLiked ? Colors.green : Colors.grey[600],
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "${widget.answer.votes}",
                            style: TextStyle(
                              fontSize: 12,
                              color: isLiked ? Colors.green : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return ReplyBottomSheetWidget(
                              answer: widget.answer,
                              qnaCubit: widget.qnaCubit,
                              username: widget.user.name,
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Icon(Icons.reply, size: 16, color: Colors.blue),
                          const SizedBox(width: 4),
                          const Text(
                            "رد",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReplyBottomSheetWidget extends StatefulWidget {
  const ReplyBottomSheetWidget({
    super.key,
    required this.answer,
    required this.qnaCubit,
    required this.username,
  });
  final QnaAnswerModel answer;
  final QnaCubit qnaCubit;

  final String username;

  @override
  State<ReplyBottomSheetWidget> createState() => _ReplyBottomSheetWidgetState();
}

class _ReplyBottomSheetWidgetState extends State<ReplyBottomSheetWidget> {
  late final TextEditingController _replyController;

  @override
  void initState() {
    super.initState();
    _replyController = TextEditingController();
    // open keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _submitReply() async {
    if (_replyController.text.trim().isEmpty) return;

    // إنشاء الرد على التعليق
    final newReply = QnaAnswerModel(
      id: '',
      questionId: widget.answer.questionId,
      authorId: FirebaseAuth.instance.currentUser!.uid,
      text: _replyController.text.trim(),
      votes: 0,
      createdAt: DateTime.now(),
    );

    // إرسال الرد باستخدام الـCubit
    widget.qnaCubit.createAnswerEvent(newReply);

    _replyController.clear();
    Navigator.pop(context); // إغلاق الـ BottomSheet بعد إرسال الرد
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, //
      ),
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          height: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "جاري الرد على ${widget.username}",
                  ),
                  SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context); // إغلاق الـ BottomSheet
                    },
                    child: const Text(
                      "إلغاء",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _replyController,
                        hintText: 'اكتب إجابتك...',
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
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.loginRoute);
                            },
                          );
                        } else {
                          _submitReply();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
