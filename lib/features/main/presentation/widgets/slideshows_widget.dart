import 'dart:async';
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

    return BlocConsumer<MainCubit, MainState>(
      bloc: mainCubit,
      listenWhen: (previous, current) => current is ViewSlideshowDetailsState,
      listener: (context, state) {
        if (state is ViewSlideshowDetailsState) {
          if (context.read<UsersCubit>().currentUser?.permissions.isAdmin ??
              false) {
            AppAlert.showAlertWidget(
              context,
              child: Column(
                children: [
                  Text(
                    state.slideshow.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (state.slideshow.route.isNotEmpty) const Divider(),
                  if (state.slideshow.route.isNotEmpty)
                    ListTile(
                      title: const Text("عرض"),
                      leading: const Icon(Icons.add),
                      onTap: () {
                        AppAlert.dismissDialog(context);
                        Navigator.pushNamed(context, state.slideshow.route);
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
                          'slideshow': state.slideshow,
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state.slideshow.route.isNotEmpty) {
            Navigator.pushNamed(context, state.slideshow.route);
          }
        }
      },
      buildWhen: (previous, current) => current is SlideshowsSuccessState,
      builder: (context, state) {
        if (state is SlideshowsSuccessState && mainCubit.slideshows.isNotEmpty) {
          return SizedBox(
            height: 150,
            width: double.infinity,
            child: FlipSlideshowsWidget(
              slideshows: mainCubit.slideshows,
              mainCubit: mainCubit,
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class FlipSlideshowsWidget extends StatefulWidget {
  const FlipSlideshowsWidget({
    super.key,
    required this.slideshows,
    required this.mainCubit,
  });
  final List<SlideshowModel> slideshows;
  final MainCubit mainCubit;

  @override
  State<FlipSlideshowsWidget> createState() => _FlipSlideshowsWidgetState();
}

class _FlipSlideshowsWidgetState extends State<FlipSlideshowsWidget> {
  late final PageController _pageController;
  late Timer _autoScrollTimer;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        if (_pageController.hasClients) {
          final nextPage = (_pageController.page?.toInt() ?? 0) + 1;

          if (nextPage < widget.slideshows.length) {
            _pageController.animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } else {
            _pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ); // العودة إلى الصفحة الأولى مباشرة
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.slideshows.length,
      itemBuilder: (context, index) {
        final SlideshowModel slideShow = widget.slideshows[index];
        return SlideWidget(slideShow: slideShow, mainCubit: widget.mainCubit);
      },
    );
  }
}

class SlideWidget extends StatelessWidget {
  const SlideWidget({
    super.key,
    required this.slideShow,
    required this.mainCubit,
  });

  final SlideshowModel slideShow;
  final MainCubit mainCubit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        mainCubit.viewSlideshowDetailsEvint(slideShow);
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  slideShow.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Description
            Positioned(
              bottom: 4,
              left: 4,
              right: 4,
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
                    fontSize: 13.0,
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
  }
}
