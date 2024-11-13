import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/core/widgets/custom_text_field.dart';
import 'package:linkati/features/challenges/data/models/topic_model.dart';

import '../../../../core/widgets/alert_widget.dart';
import '../cubit/challenges_cubit.dart';

class TopicFormScreen extends StatefulWidget {
  const TopicFormScreen({super.key, required this.topic});
  final TopicModel? topic;

  @override
  State<TopicFormScreen> createState() => _TopicFormScreenState();
}

class _TopicFormScreenState extends State<TopicFormScreen> {
  late final GlobalKey<FormState> _formKey;
  late final ChallengesCubit _challengesCubit;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    _challengesCubit = context.read<ChallengesCubit>();
    _formKey = GlobalKey<FormState>();
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _imageUrlController = TextEditingController();

    if (widget.topic != null) {
      _titleController.text = widget.topic!.title;
      _descriptionController.text = widget.topic!.description;
      _imageUrlController.text = widget.topic!.imageUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اضافة قسم جديد'),
      ),
      body: BlocListener<ChallengesCubit, ChallengesState>(
        bloc: _challengesCubit,
        listener: (context, state) {
          if (state is ManageTopicErrorState) {
            AppAlert.showAlert(context, subTitle: state.failure);
          }
          if (state is ManageTopicSuccessState) {
            AppAlert.showAlert(context, subTitle: 'تمت العملية بنجاح').then(
              (value) {
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            );
          }
          if (state is ManageTopicLoadingState) {
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
                  controller: _titleController,
                  labelText: 'عنوان القسم',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى ادخال عنوان القسم';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: _descriptionController,
                  labelText: 'وصف القسم',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى ادخال وصف القسم';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: _imageUrlController,
                  labelText: 'صورة القسم',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى ادخال صورة القسم';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomButtonWidget(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final topic = TopicModel(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        imageUrl: _imageUrlController.text,
                        id: '',
                        questionCount: 0,
                      );
                      if (widget.topic != null) {
                        _challengesCubit.updateTopicEvent(topic);
                      } else {
                        _challengesCubit.createTopicEvent(topic);
                      }
                    }
                  },
                  label:
                      widget.topic != null ? 'تحديث القسم' : 'اضافة قسم جديد',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
