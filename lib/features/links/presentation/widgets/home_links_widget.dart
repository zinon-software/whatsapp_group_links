import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkati/core/utils/color_manager.dart';
import 'package:linkati/core/widgets/custom_skeletonizer_widget.dart';

import '../../../../core/ads/ads_manager.dart';
import '../../../../core/routes/app_routes.dart';
import '../../data/models/link_model.dart';
import 'link_card_widget.dart';

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
              return CustomSkeletonizerWidget(
                enabled: true,
                child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return LinkCardWidget(
                        adsManager: adsManager,
                        link: LinkModel.isEmpty(),
                        width: MediaQuery.sizeOf(context).width - 70,
                        height: 85,
                      );
                    },
                  ),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('خطأ: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('لا يوجد روابط'),
              );
            }

            List<LinkModel> linksData = snapshot.data!.docs.map((doc) {
              var linkData = doc.data() as Map<String, dynamic>;
              return LinkModel.fromJson(linkData);
            }).toList();

            return SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: linksData.length,
                itemBuilder: (context, index) {
                  final LinkModel link = linksData[index];

                  return Row(
                    children: [
                      LinkCardWidget(
                        adsManager: adsManager,
                        link: link,
                        width: MediaQuery.sizeOf(context).width - 70,
                        height: 85,
                      ),
                      if (index == linksData.length - 1)
                        Container(
                          height: 85,
                          width: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: ColorsManager.card,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.black,
                          ),
                        ),
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
