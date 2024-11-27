import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/core/widgets/custom_text_field.dart';
import 'package:linkati/features/main/data/models/slideshow_model.dart';
import 'package:linkati/features/main/presentation/cubit/main_cubit.dart';

class SlideshowFormScreen extends StatefulWidget {
  const SlideshowFormScreen({super.key, this.slideshow});
  final SlideshowModel? slideshow;

  @override
  State<SlideshowFormScreen> createState() => _SlideshowFormScreenState();
}

class _SlideshowFormScreenState extends State<SlideshowFormScreen> {
  late final GlobalKey<FormState> _formKey;
  late final MainCubit _mainCubit;

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _routeController;
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _mainCubit = context.read<MainCubit>();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _imageUrlController = TextEditingController();
    _routeController = TextEditingController(text: "");
    _urlController = TextEditingController(text: '');

    if (widget.slideshow != null) {
      _titleController.text = widget.slideshow!.title;
      _descriptionController.text = widget.slideshow!.description;
      _imageUrlController.text = widget.slideshow!.imageUrl;
      _routeController.text = widget.slideshow!.route;
      _urlController.text = widget.slideshow!.url;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _routeController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      SlideshowModel slideshow;

      if (widget.slideshow != null) {
        slideshow = widget.slideshow!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          imageUrl: _imageUrlController.text,
          route: _routeController.text,
          url: _urlController.text,
        );
        _mainCubit.updateSlideshowEvint(slideshow);
      } else {
        slideshow = SlideshowModel(
          id: DateTime.now().toString(),
          title: _titleController.text,
          description: _descriptionController.text,
          imageUrl: _imageUrlController.text,
          route: _routeController.text,
          url: _urlController.text,
        );
        _mainCubit.createSlideshowEvint(slideshow);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slideshow Form'),
      ),
      body: BlocListener<MainCubit, MainState>(
        bloc: _mainCubit,
        listenWhen: (previous, current) =>
            current is ManageSlideshowLoadingState ||
            current is ManageSlideshowErrorState ||
            current is ManageSlideshowSuccessState,
        listener: _onListener,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                CustomTextField(
                  controller: _titleController,
                  labelText: 'العنوان',
                  validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _descriptionController,
                  labelText: 'الوصف',
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  maxLength: 100,
                  validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _imageUrlController,
                  labelText: 'رابط الصورة',
                  validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _routeController,
                  labelText: 'المسار',
                  isNotValidator: true,
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _urlController,
                  labelText: 'الرابط',
                  isNotValidator: true,
                ),
                SizedBox(height: 30),
                CustomButtonWidget(
                  onPressed: submit,
                  label: 'حفظ',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onListener(context, state) {
    if (state is ManageSlideshowSuccessState) {
      AppAlert.showAlert(context, subTitle: 'تمت العملية بنجاح').then(
        (value) {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        },
      );
    }
    if (state is ManageSlideshowErrorState) {
      AppAlert.showAlert(context, subTitle: state.message);
    }
    if (state is ManageSlideshowLoadingState) {
      AppAlert.loading(context);
    }
  }
}
