import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/routes/app_routes.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../../../core/widgets/custom_button_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  //دالة البناء لتمثيل واجهة المستخدم
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final UsersCubit usersCubit = context.read<UsersCubit>();

    return Scaffold(
      body: BlocListener<UsersCubit, UsersState>(
        bloc: usersCubit,
        listener: (context, state) {
          if (state is LoginRouteToHomeState) {
            AppAlert.dismissDialog(context);
            Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
          }
          if (state is SignInWithGoogleErrorState) {
            AppAlert.customDialog(
              context,
              icon: Icons.error,
              title: 'خطأ',
              subTitle: state.error,
            );
          }

          if (state is SignInWithGoogleLoadingState) {
            AppAlert.loading(context);
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Image.asset(
                    'assets/images/registration.png',
                    height: screenHeight * 0.3,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  const Text(
                    'تسجيل الدخول',
                    style: TextStyle(fontSize: 28, color: Colors.black),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  const Text(
                    'أدخل رقم هاتفك المحمول لتلقي رمز التحقق',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  CustomButtonWidget(
                    label: "تسجيل الدخول بواسطة Google",
                    height: 45,
                    width: double.infinity,
                    backgroundColor: const Color.fromARGB(255, 253, 188, 51),
                    textColor: Colors.black,
                    onPressed: () {
                      usersCubit.onSignInWithGoogleEvent();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
