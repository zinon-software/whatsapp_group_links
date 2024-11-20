import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/core/widgets/custom_cached_network_image_widget.dart';
import 'package:linkati/features/main/presentation/cubit/main_cubit.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../../../core/routes/app_routes.dart';
import '../../data/models/slideshow_model.dart';

class SlideshowsWidget extends StatelessWidget {
  const SlideshowsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MainCubit mainCubit = context.read<MainCubit>();

    return BlocBuilder<MainCubit, MainState>(
      bloc: mainCubit,
      buildWhen: (previous, current) => current is SlideshowsSuccessState,
      builder: (context, state) {
        if (state is SlideshowsSuccessState && state.slideshows.isNotEmpty) {
          return SizedBox(
            height: 150,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.slideshows.length,
              itemBuilder: (context, index) {
                final SlideshowModel slideShow = state.slideshows[index];
                return GestureDetector(
                  onTap: () {
                    if (context
                            .read<UsersCubit>()
                            .currentUser
                            ?.permissions
                            .isAdmin ??
                        false) {
                      AppAlert.showAlertWidget(
                        context,
                        child: Column(
                          children: [
                            const Text("تحكم في الاسليشوزات"),
                            if (slideShow.route.isNotEmpty) const Divider(),
                            if (slideShow.route.isNotEmpty)
                              ListTile(
                                title: const Text("عرض"),
                                leading: const Icon(Icons.add),
                                onTap: () {
                                  AppAlert.dismissDialog(context);
                                  Navigator.pushNamed(context, slideShow.route);
                                },
                              ),
                            const Divider(),
                            ListTile(
                              title: const Text("تعديل"),
                              leading: const Icon(Icons.edit),
                              onTap: () {
                                AppAlert.dismissDialog(context);
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.slideshowFormRoute,
                                  arguments: {
                                    'slideshow': slideShow,
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    } else if (slideShow.route.isNotEmpty) {
                      Navigator.pushNamed(context, slideShow.route);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CustomCachedNetworkImage(
                            slideShow.imageUrl,
                            width: MediaQuery.of(context).size.width - 16,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // titel
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              slideShow.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // description
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            width: MediaQuery.of(context).size.width - 16,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              slideShow.description,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
