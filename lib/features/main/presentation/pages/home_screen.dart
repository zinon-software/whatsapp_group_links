import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:linkati/core/routes/app_routes.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/core/widgets/custom_cached_network_image_widget.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../../../../core/ads/ads_manager.dart';
import '../../../../config/app_injector.dart';
import '../../../../core/api/app_collections.dart';
import '../../../../core/notification/notification_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../links/presentation/widgets/home_links_widget.dart';
import '../cubit/main_cubit.dart';
import '../views/block_ads_view.dart';
import '../views/fortune_wheel_view.dart';
import '../widgets/admin_dashboard_button_widget.dart';
import '../widgets/home_button_widget.dart';
import '../widgets/icon_floating_button.dart';
import '../widgets/slideshows_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final UsersCubit _usersCubit;
  late final MainCubit _mainCubit;

  late AdsManager _adsManager;

  @override
  void initState() {
    _usersCubit = context.read<UsersCubit>();
    _mainCubit = context.read<MainCubit>();
    super.initState();
    _adsManager = AdsManager();
    _adsManager.loadRewardedAd();
    _adsManager.loadInterstitialAd();
    _adsManager.loadNativeAd();
    appReview();

    _usersCubit.fetchMyUserAccount();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        NotificationManager.navigatorRoutes(initialMessage.data["route"]);
      }
    });
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
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return _mainCubit.onWillPop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("مجموعاتي"),
          centerTitle: false,
          actions: [
            BlocBuilder<UsersCubit, UsersState>(
              bloc: _usersCubit,
              builder: (context, state) {
                if (_usersCubit.currentUser == null) {
                  return IconButton(
                    icon: const Icon(Icons.login),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.loginRoute);
                    },
                  );
                } else {
                  // user account
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.accountRoute);
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "${_usersCubit.currentUser?.score} نقطة 🪙",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundImage: CustomCachedNetworkImage(
                              _usersCubit.currentUser!.photoUrl,
                            ).imageProvider,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            )
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SlideshowsWidget(),
                  AdminDashboardButtonWidget(usersCubit: _usersCubit),
                  HomeButtonWidget(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.usersRankRoute,
                      );
                    },
                    logo: 'assets/svg/rank.svg',
                    title: "المتسابقين",
                    subtitle: "عرض الترتيب الحالي للمشاركين",
                    icon: Icons.group,
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
                    subtitle: "استعراض أحدث التحديات المتاحة",
                    icon: Icons.lightbulb,
                  ),
                  HomeButtonWidget(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.qnasRoute,
                      );
                    },
                    logo: 'assets/svg/ask.svg',
                    title: "مجتمع تساؤلات",
                    subtitle: "مشاركة الأسئلة والأجوبة مع المجتمع",
                    icon: Icons.question_answer,
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
                  Center(
                    child: _adsManager.getNativeAdWidget(),
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
                  Center(
                    child: _adsManager.getNativeAdWidget(),
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
                  Center(
                    child: _adsManager.getNativeAdWidget(),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            // daily spin
            IconFloatingButton(
              top: 200,
              right: 10,
              onPressed: () {
                if (_usersCubit.auth.currentUser == null) {
                  AppAlert.showAlert(
                    context,
                    subTitle: "يرجى تسجيل الدخول",
                    confirmText: "تسجيل الدخول",
                    onConfirm: () {
                      AppAlert.dismissDialog(context);
                      Navigator.of(context).pushNamed(
                        AppRoutes.loginRoute,
                      );
                    },
                  );
                } else {
                  AppAlert.showAlertWidget(
                    context,
                    dismissOn: false,
                    child: DailySpinView(
                      adsManager: _adsManager,
                      usersCubit: _usersCubit,
                    ),
                  );
                }
              },
              child: Icon(
                CupertinoIcons.game_controller_solid,
                color: ColorsManager.primaryLight,
                size: 45,
              ),
            ),
            // block ads
            IconFloatingButton(
              top: 250,
              right: 10,
              onPressed: () {
                AppAlert.showAlertWidget(
                  context,
                  dismissOn: false,
                  child: const BlockAdsView(),
                  customHeader: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsManager.fillColor,
                      backgroundBlendMode: BlendMode.overlay,
                      border: Border.all(
                        width: 1,
                        color: ColorsManager.primaryLight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image(
                      image: const AssetImage("assets/images/block_ads.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
              child: Image(
                image: const AssetImage("assets/images/block_ads.png"),
                fit: BoxFit.fill,
                height: 45,
                width: 45,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "add_link${DateTime.now().millisecondsSinceEpoch}",
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
