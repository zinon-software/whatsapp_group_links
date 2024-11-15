import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:linkati/core/routes/app_routes.dart';
import 'package:linkati/core/utils/color_manager.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../../../../core/ads/ads_manager.dart';
import '../../../../config/app_injector.dart';
import '../../../../core/api/app_collections.dart';
import '../../../links/presentation/widgets/home_links_widget.dart';
import '../widgets/home_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final UsersCubit _usersCubit;

  late AdsManager _adsManager;

  @override
  void initState() {
    _usersCubit = context.read<UsersCubit>();
    super.initState();
    _adsManager = AdsManager();
    _adsManager.loadRewardedAd();
    _adsManager.loadNativeAd();
    appReview();
  }

  appReview() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  @override
  void dispose() {
    _adsManager.disposeNativeAd();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (route, result) {},
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("مجموعاتي")),
          actions: [
            BlocBuilder<UsersCubit, UsersState>(
              bloc: _usersCubit,
              builder: (context, state) {
                if (_usersCubit.auth.currentUser == null) {
                  return IconButton(
                    icon: const Icon(Icons.login),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.loginRoute);
                    },
                  );
                } else {
                  // user account
                  return IconButton(
                    icon: const Icon(Icons.account_circle),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.accountRoute);
                    },
                  );
                }
              },
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BlocBuilder<UsersCubit, UsersState>(
                  bloc: _usersCubit,
                  builder: (context, state) {
                    if (_usersCubit.currentUser?.permissions.isAdmin ?? false) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtonWidget(
                          width: double.infinity,
                          backgroundColor: ColorsManager.aed5e5,
                          textColor: ColorsManager.primaryLight,
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.linksDashboardRoute,
                            );
                          },
                          label: "لوحة التحكم",
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                HomeButtonWidget(
                  onTap: () {
                    if (_usersCubit.auth.currentUser == null) {
                      AppAlert.showAlert(
                        context,
                        subTitle: "يرجى تسجيل الدخول",
                        confirmText: "تسجيل الدخول",
                        onConfirm: () {
                          AppAlert.dismissDialog(context);
                          Navigator.of(context).pushNamed(
                            AppRoutes.loginRoute,
                            arguments: {
                              "next_route": AppRoutes.topicsRoute,
                            },
                          );
                        },
                      );
                    } else {
                      Navigator.of(context).pushNamed(
                        AppRoutes.topicsRoute,
                      );
                    }
                  },
                  logo: 'assets/svg/challenges.svg',
                  title: "التحديات",
                  icon: Icons.lightbulb,
                ),
                HomeButtonWidget(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.usersRankRoute,
                    );
                  },
                  logo: 'assets/svg/rank.svg',
                  title: "المتسابقين",
                  icon: Icons.group,
                ),
                HomeLinksWidget(
                  query: instance<AppCollections>()
                      .links
                      .orderBy("views", descending: true),
                  title: "الاكثر مشاهدة",
                  adsManager: _adsManager,
                ),
                HomeLinksWidget(
                  adsManager: _adsManager,
                  title: "الاحدث",
                  query: instance<AppCollections>()
                      .links
                      .orderBy('create_dt', descending: true),
                ),
                HomeLinksWidget(
                  query: instance<AppCollections>()
                      .links
                      .orderBy("create_dt", descending: false),
                  title: "الاقدم",
                  adsManager: _adsManager,
                ),

                HomeLinksWidget(
                  query: instance<AppCollections>()
                      .links
                      .where("type", isEqualTo: "whatsapp"),
                  title: "مجموعات واتساب WhatsApp",
                  adsManager: _adsManager,
                ),
                // telegram
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: _adsManager.getNativeAdWidget(),
                  ),
                ),
                HomeLinksWidget(
                  adsManager: _adsManager,
                  query: instance<AppCollections>()
                      .links
                      .where("type", isEqualTo: "telegram"),
                  title: "قنوات تيليجرام Telegram",
                ),
                // ficebook
                HomeLinksWidget(
                  adsManager: _adsManager,
                  query: instance<AppCollections>()
                      .links
                      .where("type", isEqualTo: "facebook"),
                  title: "مجموعات وصفحات فيسبوك Facebook",
                ),
                // twitter
                HomeLinksWidget(
                  adsManager: _adsManager,
                  query: instance<AppCollections>()
                      .links
                      .where("type", isEqualTo: "twitter"),
                  title: "حسابات تويتر Twitter",
                ),
                // instagram
                HomeLinksWidget(
                  adsManager: _adsManager,
                  query: instance<AppCollections>()
                      .links
                      .where("type", isEqualTo: "instagram"),
                  title: "حسابات انستجرام Instagram",
                ),

                // snapchat
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: _adsManager.getNativeAdWidget(),
                  ),
                ),
                HomeLinksWidget(
                  adsManager: _adsManager,
                  query: instance<AppCollections>()
                      .links
                      .where("type", isEqualTo: "snapchat"),
                  title: "حسابات سنابشات Snapchat",
                ),
                // tiktok
                HomeLinksWidget(
                  adsManager: _adsManager,
                  query: instance<AppCollections>()
                      .links
                      .where("type", isEqualTo: "tiktok"),
                  title: "حسابات تيك توك TikTok",
                ),
                // youtube
                HomeLinksWidget(
                  adsManager: _adsManager,
                  query: instance<AppCollections>()
                      .links
                      .where("type", isEqualTo: "youtube"),
                  title: "قنوات يوتيوب Youtube",
                ),
                // linkedin
                HomeLinksWidget(
                  adsManager: _adsManager,
                  query: instance<AppCollections>()
                      .links
                      .where("type", isEqualTo: "linkedin"),
                  title: "حسابات لينكدان LinkedIn",
                ),
                // other
                HomeLinksWidget(
                  query: instance<AppCollections>()
                      .links
                      .where("type", isEqualTo: "other"),
                  title: "روابط اخرى",
                  adsManager: _adsManager,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: _adsManager.getNativeAdWidget(),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _adsManager.showRewardedAd();
            Navigator.of(context).pushNamed(AppRoutes.linkFormRoute);
          },
          child: const Icon(CupertinoIcons.add),
        ),
      ),
    );
  }
}
