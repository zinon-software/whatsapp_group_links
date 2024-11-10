import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/ads/ads_manager.dart';
import '../../../../core/routes/app_routes.dart';
import '../../data/models/link_model.dart';
import 'link_item_widget.dart';

class HomeLinksWidget extends StatelessWidget {
  const HomeLinksWidget({
    super.key,
    required this.adsManager,
    required this.query,
    required this.title,
  });

  final AdsManager adsManager;
  final Query<Object?> query;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              InkWell(
                onTap: () {
                  adsManager.showRewardedAd();
                  Navigator.pushNamed(context, AppRoutes.linksRoute,
                      arguments: {
                        'title': title,
                        'query': query,
                      });
                },
                child: const Row(
                  children: [
                    Text(
                      "مشاهدة المزيد",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 20),
                    Icon(CupertinoIcons.arrowshape_turn_up_left_2)
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: query.limit(10).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('خطأ: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('لا يوجد روابط'),
              );
            }

            return SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var linkData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;

                  var link = LinkModel.fromJson(linkData);

                  return Column(
                    children: [
                      if ((index + 1) % 10 == 0)
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: adsManager.getNativeAdWidget(),
                          ),
                        ),
                      LinkItemWidget(adsManager: adsManager, link: link),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
