import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkati/core/widgets/custom_skeletonizer_widget.dart';

import '../../../../core/ads/ads_manager.dart';
import '../../data/models/link_model.dart';
import '../widgets/link_card_widget.dart';

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
          _adsManager.getBannerAdWidget(padding: const EdgeInsets.all(8.0)),
          Expanded(
            child: FirestoreQueryBuilder<LinkModel>(
              pageSize: 20,
              query: widget.query.withConverter<LinkModel>(
                fromFirestore: (snapshot, _) => LinkModel.fromJson(
                  snapshot.data() as Map<String, dynamic>,
                ),
                toFirestore: (link, _) => link.toJson(),
              ),
              builder: (context, snapshot, _) {
                if (snapshot.isFetching) {
                  return CustomSkeletonizerWidget(
                    enabled: true,
                    child: ListView.builder(
                      itemBuilder: (context, index) => Column(
                        children: [
                          LinkCardWidget(
                            adsManager: _adsManager,
                            link: LinkModel.isEmpty(),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                      itemCount: 10,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.docs.isEmpty) {
                  return const Center(
                    child: Text('No social media links available.'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.docs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                      // Tell FirestoreQueryBuilder to try to obtain more items.
                      // It is safe to call this function from within the build method.
                      snapshot.fetchMore();
                    }

                    final LinkModel link = snapshot.docs[index].data();

                    return Column(
                      children: [
                        if ((index + 1) % 10 == 0)
                          Center(
                            child: _adsManager.getNativeAdWidget(),
                          ),
                        LinkCardWidget(adsManager: _adsManager, link: link),
                        SizedBox(height: 10),
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
