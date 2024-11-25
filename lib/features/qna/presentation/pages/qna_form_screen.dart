import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/features/qna/data/models/qna_question_model.dart';
import 'package:linkati/features/qna/presentation/cubit/qna_cubit.dart';

import '../../../../core/widgets/alert_widget.dart';
import '../../../../core/widgets/custom_button_widget.dart';
import '../../../../core/widgets/custom_text_field.dart';

class QnaFormScreen extends StatefulWidget {
  const QnaFormScreen({super.key, this.question});
  final QnaQuestionModel? question;

  @override
  State<QnaFormScreen> createState() => _QnaFormScreenState();
}

class _QnaFormScreenState extends State<QnaFormScreen> {
  late final GlobalKey<FormState> _formKey;
  late final QnaCubit _qnaCubit;

  late final TextEditingController _textController;
  late final TextEditingController _categoryController;
  bool isPublic = true;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _qnaCubit = context.read<QnaCubit>();

    _textController = TextEditingController();
    _categoryController = TextEditingController();

    if (widget.question != null) {
      _textController.text = widget.question!.text;
      _categoryController.text = widget.question!.category ?? '';
      isPublic = widget.question!.isPublic;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (widget.question != null) {
        _qnaCubit.updateQuestionEvent(
          widget.question!.copyWith(
            id: widget.question!.id,
            text: _textController.text,
            category: _categoryController.text,
            isPublic: isPublic,
          ),
        );
      } else {
        _qnaCubit.createQuestionEvent(
          QnaQuestionModel(
            id: '',
            text: _textController.text,
            category: _categoryController.text,
            isPublic: isPublic,
            isAnswered: false,
            isActive: true,
            createdAt: DateTime.now(),
            answersCount: 0,
            authorId: FirebaseAuth.instance.currentUser!.uid,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.question != null ? 'تعديل السؤال' : 'إضافة سؤال'),
      ),
      body: BlocListener<QnaCubit, QnaState>(
        bloc: _qnaCubit,
        listenWhen: (previous, current) =>
            current is ManageQuestionLoadingState ||
            current is ManageQuestionSuccessState ||
            current is ManageQuestionErrorState,
        listener: (context, state) {
          if (state is ManageQuestionLoadingState) {
            AppAlert.loading(context);
          }
          if (state is ManageQuestionSuccessState) {
            AppAlert.showAlert(context, subTitle: "تمت العملية بنجاح").then(
              (value) {
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            );
          }
          if (state is ManageQuestionErrorState) {
            AppAlert.showAlert(context, subTitle: state.message);
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                CustomTextField(
                  controller: _textController,
                  labelText: 'السؤال',
                  validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  value: _categoryController.text == ''
                      ? null
                      : _categoryController.text,
                  items: const [
                    DropdownMenuItem(
                      value: 'عام',
                      child: Text('عام'),
                    ),
                    DropdownMenuItem(
                      value: 'تعليمي',
                      child: Text('تعليمي'),
                    ),
                    DropdownMenuItem(
                      value: 'ثقافي',
                      child: Text('ثقافي'),
                    ),
                    DropdownMenuItem(
                      value: 'اجتماعي',
                      child: Text('اجتماعي'),
                    ),
                    DropdownMenuItem(
                      value: 'ترفيهي',
                      child: Text('ترفيهي'),
                    ),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'التصنيف',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _categoryController.text = value.toString();
                  },
                  validator: (value) => value == null ? 'مطلوب' : null,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  value: isPublic,
                  items: const [
                    DropdownMenuItem(value: true, child: Text('عام')),
                    DropdownMenuItem(value: false, child: Text('خاص')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'نوع السؤال',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      isPublic = value as bool;
                    });
                  },
                  validator: (value) => value == null ? 'مطلوب' : null,
                ),
                SizedBox(height: 30),
                CustomButtonWidget(
                  width: double.infinity,
                  onPressed: _submit,
                  label: 'حفظ',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
