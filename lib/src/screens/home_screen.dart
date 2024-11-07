import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkati/src/extensions/date_format_extension.dart';
import 'package:linkati/src/routes/app_routes.dart';

import '../managers/ads_manager.dart';
import '../managers/cloud_manager.dart';
import '../models/link_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  final CloudManager cloudManager = CloudManager();
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _adsManager.getBannerAdWidget(),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: cloudManager.linksCollection.snapshots(),
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
                    link.documentId = snapshot.data!.docs[index].id;

                    return Column(
                      children: [
                        if ((index + 1) % 10 == 0)
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: _adsManager.getNativeAdWidget(),
                            ),
                          ),
                        InkWell(
                          onTap: () {
                            _adsManager.showRewardedAd();
                            Navigator.of(context).pushNamed(
                              AppRoutes.linkDetailsRoute,
                              arguments: {
                                'link': link,
                              },
                            );
                            
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(link.title),
                              subtitle: Row(
                                children: [
                                  Text(link.createDt.formatTimeAgoString()),
                                  const SizedBox(width: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      link.type,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Text('${link.views} مشاهدة'),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
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
