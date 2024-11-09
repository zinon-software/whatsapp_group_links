import 'package:flutter/material.dart';
import 'package:linkati/core/extensions/date_format_extension.dart';

import '../../../../core/ads/ads_manager.dart';
import '../../../../core/routes/app_routes.dart';
import '../../data/models/link_model.dart';

class LinkItemWidget extends StatelessWidget {
  const LinkItemWidget({
    super.key,
    required AdsManager adsManager,
    required this.link,
  }) : _adsManager = adsManager;

  final AdsManager _adsManager;
  final LinkModel link;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width - 60,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Image.asset(
                'assets/images/${link.type.toLowerCase()}.png',
              ),
            ),
            title:
                Text(link.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(link.createDt.formatTimeAgoString()),
            trailing: Text('${link.views} مشاهدة'),
          ),
        ),
      ),
    );
  }
}
