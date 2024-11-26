import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/alert_widget.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../users/presentation/cubit/users_cubit.dart';
import 'home_button_widget.dart';

class AdminDashboardButtonWidget extends StatelessWidget {
  const AdminDashboardButtonWidget({
    super.key,
    required this.usersCubit,
  });

  final UsersCubit usersCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      bloc: usersCubit,
      builder: (context, state) {
        if (usersCubit.currentUser?.permissions.isAdmin ?? false) {
          return HomeButtonWidget(
            onTap: () {
              AppAlert.showAlertWidget(
                context,
                child: Column(
                  children: [
                    const Text(
                      "لوحة التحكم",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text("المستخدمين"),
                      onTap: () {
                        // Navigator.pushNamed(context, AppRoutes.usersRoute);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.link),
                      title: const Text("الروابط"),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.linksDashboardRoute,
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text("إضافة slideshow"),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.slideshowFormRoute,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
            logo: 'assets/svg/challenges.svg',
            title: "لوحة التحكم",
            subtitle: "لوحة التحكم",
            icon: Icons.shield,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
