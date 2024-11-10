import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/alert_widget.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/custom_button_widget.dart';
import '../../../../core/widgets/custom_cached_network_image_widget.dart';
import '../cubit/users_cubit.dart';
import '../widgets/selected_country_widget.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UsersCubit usersCubit = context.read<UsersCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("الحساب"),
      ),
      body: BlocConsumer<UsersCubit, UsersState>(
        bloc: usersCubit,
        listener: (context, state) {
          if (state is LogoutRouteToLoginState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.loginRoute,
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // User Profile Card
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // User Photo
                            if (usersCubit.currentUser?.photoUrl != null)
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: CustomCachedNetworkImage(
                                  usersCubit.currentUser?.photoUrl ?? '',
                                ).imageProvider,
                              ),
                            const SizedBox(height: 10),
                            // User Score
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star, color: Colors.amber),
                                const SizedBox(width: 5),
                                Text(
                                  usersCubit.currentUser?.score.toString() ??
                                      '0',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // User Name
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person, color: Colors.grey[700]),
                                const SizedBox(width: 5),
                                Text(
                                  usersCubit.currentUser?.name ??
                                      'اسم المستخدم غير متاح',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            // User Email
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.email, color: Colors.grey[700]),
                                const SizedBox(width: 5),
                                Text(
                                  usersCubit.currentUser?.email ??
                                      'البريد الإلكتروني غير متاح',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            // User Phone
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.phone, color: Colors.grey[700]),
                                const SizedBox(width: 5),
                                Text(
                                  usersCubit.currentUser?.phoneNumber ??
                                      'رقم الهاتف غير متاح',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // contry
                            if (usersCubit.currentUser?.country != null)
                              Text(
                                usersCubit.currentUser?.country ??
                                    'الدولة غير متاحة',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              )
                            else
                              // add country
                              SelectedCountryWidget(
                                lang: 'ar',
                                onChanged: (countryName) {
                                  usersCubit.onUpdateUser(
                                    usersCubit.currentUser!.copyWith(
                                      country: countryName,
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Sign Out Button
                    CustomButtonWidget(
                      label: "تسجيل الخروج",
                      icon: Icons.logout,
                      onPressed: () async {
                        AppAlert.showAlert(
                          context,
                          title: "تسجيل الخروج",
                          subTitle: "هل تريد تسجيل الخروج؟",
                          confirmText: "تسجيل الخروج",
                          onConfirm: () {
                            usersCubit.signOut();
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    // Privacy Policy Button
                    CustomButtonWidget(
                      label: "سياسة الخصوصية",
                      icon: Icons.privacy_tip,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.privacyPolicyRoute,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
