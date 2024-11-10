import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/custom_text_field.dart';
import 'package:linkati/features/challenges/data/models/question_model.dart';
import 'package:linkati/features/challenges/presentation/cubit/challenges_cubit.dart';

import '../../../../core/utils/color_manager.dart';
import '../../../../core/widgets/alert_widget.dart';
import '../../../../core/widgets/custom_button_widget.dart';

class QuestionFormScreen extends StatefulWidget {
  const QuestionFormScreen({super.key, this.question, this.section});
  final QuestionModel? question;
  final String? section;

  @override
  State<QuestionFormScreen> createState() => _QuestionFormScreenState();
}

class _QuestionFormScreenState extends State<QuestionFormScreen> {
  late final GlobalKey<FormState> _formKey;
  late final ChallengesCubit _challengesCubit;
  late final TextEditingController _questionController;
  late final TextEditingController _correctAnswerController;

  List<String> options = [];
  String? section;

  @override
  void initState() {
    _challengesCubit = context.read<ChallengesCubit>();
    _formKey = GlobalKey<FormState>();
    super.initState();

    _questionController = TextEditingController();
    _correctAnswerController = TextEditingController();

    section = widget.section;

    if (widget.question != null) {
      _questionController.text = widget.question!.question;
      _correctAnswerController.text = widget.question!.correctAnswer;
      options = widget.question!.options;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اضافة سؤال جديد'),
      ),
      body: BlocListener<ChallengesCubit, ChallengesState>(
        bloc: _challengesCubit,
        listener: (context, state) {
          if (state is ManageQuestionErrorState) {
            AppAlert.showAlert(context, subTitle: state.failure);
          }
          if (state is ManageQuestionSuccessState) {
            AppAlert.showAlert(context, subTitle: 'تمت العملية بنجاح').then(
              (value) {
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            );
          }
          if (state is ManageQuestionLoadingState) {
            AppAlert.loading(context);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: _questionController,
                  labelText: 'السؤال',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى ادخال السؤال';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: _correctAnswerController,
                  labelText: 'الاجابة الصحيحة',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى ادخال الاجابة الصحيحة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'الاجابات',
                  ),
                  onFieldSubmitted: (value) {
                    setState(() {
                      options.add(value);
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(options[index]),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                options.removeAt(index);
                              });
                            },
                          )
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                CustomButtonWidget(
                  width: double.infinity,
                  backgroundColor: ColorManager.aed5e5,
                  textColor: ColorManager.primaryLight,
                  label:
                      widget.question != null ? 'تحديث السؤال' : 'اضافة سؤال',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      QuestionModel question = QuestionModel(
                        question: _questionController.text,
                        correctAnswer: _correctAnswerController.text,
                        options: options,
                        id: widget.question?.id ?? '',
                        section: section!,
                      );
                      if (widget.question != null) {
                        _challengesCubit.updateQuestion(question);
                      } else {
                        _challengesCubit.createQuestion(question);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
