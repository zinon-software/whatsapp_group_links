import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkati/core/extensions/date_format_extension.dart';

import '../../../../config/app_injector.dart';
import '../../../../core/ads/ads_manager.dart';
import '../../../../core/api/app_collections.dart';
import '../../../../core/routes/app_routes.dart';
import '../../data/models/link_model.dart';

class LinksStreamWidget extends StatelessWidget {
  const LinksStreamWidget({
    super.key,
    required AdsManager adsManager,
  }) : _adsManager = adsManager;

  final AdsManager _adsManager;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: instance<AppCollections>()
          .links
          .orderBy('create_dt', descending: true)
          .snapshots(),
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
            var linkData =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;

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
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Image.asset(
                          'assets/images/${link.type.toLowerCase()}.png',
                        ),
                      ),
                      title: Text(link.title),
                      subtitle: Text(link.createDt.formatTimeAgoString()),
                      trailing: Text('${link.views} مشاهدة'),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
