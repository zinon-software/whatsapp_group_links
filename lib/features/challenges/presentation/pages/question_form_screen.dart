import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/custom_text_field.dart';
import 'package:linkati/features/challenges/data/models/question_model.dart';
import 'package:linkati/features/challenges/presentation/cubit/challenges_cubit.dart';

import '../../../../core/utils/color_manager.dart';
import '../../../../core/widgets/alert_widget.dart';
import '../../../../core/widgets/custom_button_widget.dart';

class QuestionFormScreen extends StatefulWidget {
  const QuestionFormScreen({super.key, this.question, this.topic});
  final QuestionModel? question;
  final String? topic;

  @override
  State<QuestionFormScreen> createState() => _QuestionFormScreenState();
}

class _QuestionFormScreenState extends State<QuestionFormScreen> {
  late final GlobalKey<FormState> _formKey;
  late final ChallengesCubit _challengesCubit;
  late final TextEditingController _questionController;
  late final TextEditingController _answersController;

  List<String> options = [];
  String? topic;
  String? correctAnswer;

  @override
  void initState() {
    _challengesCubit = context.read<ChallengesCubit>();
    _formKey = GlobalKey<FormState>();
    super.initState();

    _questionController = TextEditingController();
    _answersController = TextEditingController();

    topic = widget.topic;

    if (widget.question != null) {
      _questionController.text = widget.question!.question;
      correctAnswer = widget.question!.correctAnswer;
      options = widget.question!.options;
      topic = widget.question!.topic;
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
        listener: _onlistener,
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
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى ادخال السؤال';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _answersController,
                        labelText: 'الاجابات',
                        readOnly: options.length >= 4,
                        onFieldSubmitted: (value) {
                          if (value.isEmpty) return;
                          setState(() {
                            _answersController.clear();
                            options.add(value);
                            if (options.length == 1) {
                              correctAnswer = value;
                            }
                          });
                        },
                        validator: (value) {
                          if (options.length < 4) {
                            return "يجب اضافة 4 اجابات على الاقل";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        if (_answersController.text.isEmpty) return;
                        setState(() {
                          options.add(_answersController.text);
                          if (options.length == 1) {
                            correctAnswer = _answersController.text;
                          }
                          _answersController.clear();
                        });
                      },
                      icon: const Icon(Icons.add),
                    )
                  ],
                ),
                const SizedBox(height: 16.0),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            title: Text(options[index]),
                            value: options[index],
                            groupValue: correctAnswer,
                            onChanged: (value) {
                              setState(() {
                                correctAnswer = value;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              if (correctAnswer == options[index]) {
                                correctAnswer = options.first;
                                options.removeAt(index);
                              } else {
                                correctAnswer = null;
                                options.removeAt(index);
                              }
                            });
                          },
                        )
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                CustomButtonWidget(
                  width: double.infinity,
                  backgroundColor: ColorsManager.aed5e5,
                  textColor: ColorsManager.primaryLight,
                  label:
                      widget.question != null ? 'تحديث السؤال' : 'اضافة سؤال',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      QuestionModel question = QuestionModel(
                        question: _questionController.text,
                        correctAnswer: correctAnswer!,
                        options: options,
                        id: widget.question?.id ?? '',
                        topic: topic!,
                      );
                      if (widget.question != null) {
                        _challengesCubit.updateQuestionEvent(question);
                      } else {
                        _challengesCubit.createQuestionEvent(question);
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

  void _onlistener(context, state) {
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
  }
}
