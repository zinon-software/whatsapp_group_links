import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/routes/app_routes.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../core/ads/ads_manager.dart';
import 'links/presentation/widgets/links_stream_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final UsersCubit _usersCubit;
  late final ScrollController _scrollController;

  late AdsManager _adsManager;

  @override
  void initState() {
    _scrollController = ScrollController();
    _usersCubit = context.read<UsersCubit>();
    super.initState();
    _adsManager = AdsManager();
    _adsManager.loadBannerAd();
    _adsManager.loadRewardedAd();
    _adsManager.loadNativeAd();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _adsManager.disposeBannerAds();
    _adsManager.disposeNativeAd();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("قروباتي")),
        actions: [
          if (_usersCubit.auth.currentUser == null)
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.loginRoute);
              },
            )
          else
            // user account
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {},
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _adsManager.getBannerAdWidget(),
          ),
          if (_usersCubit.user?.permissions.isAdmin ?? false)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButtonWidget(
                width: double.infinity,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.linksDashboardRoute);
                },
                label: "لوحة التحكم",
              ),
            ),
          Expanded(
            child: LinksStreamWidget(adsManager: _adsManager),
          ),
        ],
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
