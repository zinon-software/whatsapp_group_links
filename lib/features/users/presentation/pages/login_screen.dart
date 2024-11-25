import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkati/core/routes/app_routes.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../../../core/widgets/custom_button_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
    this.nextRoute,
    this.returnRoute = false,
    this.queryParameters,
  });
  final String? nextRoute;
  final bool returnRoute;
  final Map<String, dynamic>? queryParameters;

  @override
  Widget build(BuildContext context) {
    final UsersCubit usersCubit = context.read<UsersCubit>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            child: Text("تخطي", style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.homeRoute,
                (_) => false,
              );
            },
          ),
        ],
      ),
      body: BlocListener<UsersCubit, UsersState>(
        bloc: usersCubit,
        listener: (context, state) {
          if (state is LoginRouteToHomeState) {
            usersCubit.fetchMyUserAccount();
            AppAlert.dismissDialog(context);
            if (returnRoute) {
              Navigator.pop(context);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.homeRoute,
                (_) => false,
              );
              if (nextRoute != null) {
                Navigator.pushNamed(
                  context,
                  nextRoute!,
                  arguments: queryParameters,
                );
              }
            }
          }
          if (state is SignInWithGoogleErrorState) {
            AppAlert.showAlert(
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'تسجــــيل الــدخول',
                style: TextStyle(fontSize: 28, color: Colors.black),
              ),
              Image.asset(
                // 'assets/images/registration.png',
                'assets/icon/icon.png',
                width: 280.w,
                fit: BoxFit.contain,
              ),

              const Text(
                'مرحبا بعودتك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 140.h),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // سياسة الخصوصية
                  Text(
                    "بالنقر على تسجيل الدخول",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "فأنت توافق على ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.privacyPolicyRoute,
                          );
                        },
                        child: const Text(
                          'سياسة الخصوصية',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 16),
              // تسجيل الدخول بواسطة Google
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButtonWidget(
                  label: "تسجيل الدخول بواسطة Google",
                  height: 45,
                  width: double.infinity,
                  onPressed: () {
                    usersCubit.onSignInWithGoogleEvent();
                  },
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
