import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/core/widgets/custom_text_field.dart';
import 'package:linkati/features/challenges/data/models/section_model.dart';

import '../../../../core/widgets/alert_widget.dart';
import '../cubit/challenges_cubit.dart';

class SectionFormScreen extends StatefulWidget {
  const SectionFormScreen({super.key, required this.section});
  final SectionModel? section;

  @override
  State<SectionFormScreen> createState() => _SectionFormScreenState();
}

class _SectionFormScreenState extends State<SectionFormScreen> {
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

    if (widget.section != null) {
      _titleController.text = widget.section!.title;
      _descriptionController.text = widget.section!.description;
      _imageUrlController.text = widget.section!.imageUrl;
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
          if (state is ManageSectionErrorState) {
            AppAlert.showAlert(context, subTitle: state.failure);
          }
          if (state is ManageSectionSuccessState) {
            AppAlert.showAlert(context, subTitle: 'تمت العملية بنجاح').then(
              (value) {
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            );
          }
          if (state is ManageSectionLoadingState) {
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
                      final section = SectionModel(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        imageUrl: _imageUrlController.text,
                        id: '',
                        questionCount: 0,
                      );
                      if (widget.section != null) {
                        _challengesCubit.updateSection(section);
                      } else {
                        _challengesCubit.createSection(section);
                      }
                    }
                  },
                  label:
                      widget.section != null ? 'تحديث القسم' : 'اضافة قسم جديد',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
