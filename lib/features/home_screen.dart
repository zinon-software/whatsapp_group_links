import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/routes/app_routes.dart';
import 'package:linkati/core/utils/color_manager.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../core/ads/ads_manager.dart';
import '../config/app_injector.dart';
import '../core/api/app_collections.dart';
import 'links/presentation/widgets/home_links_widget.dart';

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
  }

  @override
  void dispose() {
    _adsManager.disposeNativeAd();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        backgroundColor: ColorManager.aed5e5,
                        textColor: ColorManager.primaryLight,
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AppRoutes.linksDashboardRoute);
                        },
                        label: "لوحة التحكم",
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              InkWell(
                onTap: () {
                  if (_usersCubit.auth.currentUser == null) {
                    AppAlert.showAlert(
                      context,
                      subTitle: "يرجى تسجيل الدخول",
                      confirmText: "تسجيل الدخول",
                      onConfirm: () {
                        AppAlert.dismissDialog(context);
                        Navigator.of(context).pushNamed(AppRoutes.loginRoute);
                      },
                    );
                  } else {
                    Navigator.of(context).pushNamed(
                      AppRoutes.sectionsRoute,
                    );
                  }
                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      color: ColorManager.aed5e5,
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle,
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.aed5e5.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ]),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/challenges.svg',
                        height: 120,
                        width: 120,
                        semanticsLabel: 'A red up arrow',
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.lightbulb,
                                color: ColorManager.f255176,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "المسابقات",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: ColorManager.f255176),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "جديد",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.usersRankRoute,
                  );
                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      color: ColorManager.aed5e5,
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle,
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.aed5e5.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ]),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/rank.svg',
                        height: 120,
                        width: 120,
                        semanticsLabel: 'A red up arrow',
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.r_mobiledata,
                                color: ColorManager.f255176,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "ترتيب المتسابقين",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: ColorManager.f255176),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "جديد",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
              HomeLinksWidget(
                adsManager: _adsManager,
                query: instance<AppCollections>()
                    .links
                    .where("type", isEqualTo: "telegram"),
                title: "مجموعات وقنوات تيليجرام Telegram",
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: _adsManager.getNativeAdWidget(),
                ),
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
              HomeLinksWidget(
                adsManager: _adsManager,
                query: instance<AppCollections>()
                    .links
                    .where("type", isEqualTo: "snapchat"),
                title: "حسابات سنابشات Snapchat",
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: _adsManager.getNativeAdWidget(),
                ),
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
    );
  }
}
