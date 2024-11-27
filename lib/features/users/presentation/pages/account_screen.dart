import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/core/widgets/alert_widget.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/custom_button_widget.dart';
import '../../../../core/widgets/custom_cached_network_image_widget.dart';
import '../../../links/presentation/widgets/my_links_widget.dart';
import '../cubit/users_cubit.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UsersCubit usersCubit = instance<UsersCubit>();
    usersCubit.fetchMyUserAccount();
    return Scaffold(
      appBar: AppBar(
        title: const Text("الحساب"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.editAccountRoute,
                arguments: {
                  'user': usersCubit.currentUser,
                  'is_edit': usersCubit.currentUser != null,
                },
              );
            },
          ),
        ],
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
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
                        Container(
                          height: 30,
                          width: 140,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "${usersCubit.currentUser?.score} نقطة 🪙",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // User Name
                        Row(
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
                        const SizedBox(height: 5),
                        // contry
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(width: 5),
                            Text(
                              usersCubit.currentUser?.country ??
                                  'الدولة غير متاحة',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
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
                const SizedBox(height: 30),
                // my links
                if (usersCubit.currentUser != null) ...[
                  const Text(
                    "الروابط التي قمت بانشاءها",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyLinksWidget(
                    userId: usersCubit.currentUser!.id,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
