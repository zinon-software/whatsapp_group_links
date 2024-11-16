import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/core/widgets/custom_text_field.dart';
import 'package:linkati/features/users/data/models/user_model.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../../../core/widgets/alert_widget.dart';
import '../widgets/selected_country_widget.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late UsersCubit _usersCubit;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String? country;

  @override
  void initState() {
    super.initState();
    country = widget.user.country;
    _usersCubit = context.read<UsersCubit>();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الحساب'),
      ),
      body: BlocListener<UsersCubit, UsersState>(
        bloc: _usersCubit,
        listener: _onListener,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 10),
                CustomTextField(
                  controller: _nameController,
                  labelText: 'الاسم',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'يرجى إدخال الاسم';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'رقم الجوال',
                  isNotValidator: true,
                ),
                SizedBox(height: 10),
                SelectedCountryWidget(
                  lang: 'ar',
                  selectedCountryName: country,
                  onChanged: (countryName) {
                    country = countryName;
                  },
                ),
                SizedBox(height: 20),
                CustomButtonWidget(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final updatedUser = widget.user.copyWith(
                        name: _nameController.text,
                        phoneNumber: _phoneController.text,
                        country: country,
                      );
                      _usersCubit.onUpdateUser(updatedUser);
                    }
                  },
                  label: 'حفظ التغييرات',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onListener(context, state) {
    if (state is UpdateUserLoadingState) {
      AppAlert.loading(context);
    }
    if (state is UpdateUserErrorState) {
      AppAlert.showAlert(context, subTitle: state.error);
    }
    if (state is UpdateUserSuccessState) {
      AppAlert.dismissDialog(context);
      Navigator.pop(context);
    }
  }
}
