import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/core/api/app_collections.dart';
import 'package:linkati/features/challenges/data/models/section_model.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/widgets/custom_button_widget.dart';
import '../../../users/presentation/cubit/users_cubit.dart';

class SectionsScreen extends StatefulWidget {
  const SectionsScreen({super.key});

  @override
  State<SectionsScreen> createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  late final UsersCubit _usersCubit;

  @override
  void initState() {
    _usersCubit = context.read<UsersCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اقسام التحديات'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            BlocBuilder<UsersCubit, UsersState>(
              bloc: _usersCubit,
              builder: (context, state) {
                if (_usersCubit.currentUser?.permissions.isAdmin ?? false) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButtonWidget(
                      width: double.infinity,
                      backgroundColor: ColorManager.aed5e5,
                      textColor: ColorManager.primaryLight,
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.challengesDashboardRoute,
                        );
                      },
                      label: "لوحة التحكم",
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Expanded(
              child: StreamBuilder(
                stream: instance<AppCollections>().sections.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No social media links available.'));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final section = SectionModel.fromJson(
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>);

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorManager.primaryLight,
                            width: 2,
                          ),
                        ),
                        child: ListTile(
                          leading: Image.network(section.imageUrl),
                          title: Text(section.title),
                          subtitle: Text(section.description),
                          trailing: TextButton(
                            onPressed: () {},
                            child: Text("المشاركة في التحدي"),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          _usersCubit.currentUser?.permissions.isAdmin ?? false
              ? FloatingActionButton(
                  backgroundColor: ColorManager.primaryLight,
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.sectionFormRoute,
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }
}
