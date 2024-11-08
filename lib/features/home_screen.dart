import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkati/core/routes/app_routes.dart';

import '../../core/ads/ads_manager.dart';
import 'links/presentation/widgets/links_stream_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  late AdsManager _adsManager;

  @override
  void initState() {
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
          if (FirebaseAuth.instance.currentUser == null)
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.loginRoute);
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                setState(() {});
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _adsManager.getBannerAdWidget(),
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

