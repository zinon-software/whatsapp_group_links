import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/core/widgets/custom_cached_network_image_widget.dart';
import 'package:linkati/features/main/presentation/cubit/main_cubit.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../../../core/routes/app_routes.dart';
import '../../data/models/slideshow_model.dart';

class SlideshowsWidget extends StatefulWidget {
  const SlideshowsWidget({super.key});

  @override
  State<SlideshowsWidget> createState() => _SlideshowsWidgetState();
}

class _SlideshowsWidgetState extends State<SlideshowsWidget> {
  final PageController _pageController = PageController();
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
  _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
    if (_pageController.hasClients) {
      final nextPage = (_pageController.page?.toInt() ?? 0) + 1;

      if (nextPage < (context.read<MainCubit>().state as SlideshowsSuccessState).slideshows.length) {
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.jumpToPage(0); // العودة إلى الصفحة الأولى مباشرة
      }
    }
  });
}


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
            child: PageView.builder(
              controller: _pageController,
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
                            fit: BoxFit.fill,
                          ),
                        ),
                        // Title
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
                        // Description
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
          return const SizedBox.shrink();
        }
      },
    );
  }
}
