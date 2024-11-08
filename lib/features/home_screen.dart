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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _adsManager.getBannerAdWidget(),
          ),
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
