import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/routes/app_routes.dart';
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
      body: SingleChildScrollView(
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
