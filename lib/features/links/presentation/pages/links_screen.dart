import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/ads/ads_manager.dart';
import '../../data/models/link_model.dart';
import '../widgets/link_item_widget.dart';

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key, required this.title, required this.query});
  final String title;
  final Query<Object?> query;

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  late AdsManager _adsManager;

  @override
  void initState() {
    _adsManager = AdsManager();
    super.initState();
    _adsManager.loadBannerAd();
    _adsManager.loadRewardedAd();
    _adsManager.loadNativeAd();
  }

  @override
  void dispose() {
    _adsManager.disposeBannerAds();

    _adsManager.disposeNativeAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _adsManager.getBannerAdWidget(),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No social media links available.'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var linkData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;

                    var link = LinkModel.fromJson(linkData);

                    return Column(
                      children: [
                        if ((index + 1) % 10 == 0)
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: _adsManager.getNativeAdWidget(),
                            ),
                          ),
                        LinkItemWidget(adsManager: _adsManager, link: link),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
