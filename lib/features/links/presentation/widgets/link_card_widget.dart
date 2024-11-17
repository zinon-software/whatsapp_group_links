import 'package:flutter/material.dart';
import 'package:linkati/core/extensions/date_format_extension.dart';
import 'package:linkati/core/utils/color_manager.dart';

import '../../../../core/ads/ads_manager.dart';
import '../../../../core/routes/app_routes.dart';
import '../../data/models/link_model.dart';

class LinkCardWidget extends StatelessWidget {
  const LinkCardWidget({
    super.key,
    required this.adsManager,
    required this.link,
    this.width = double.infinity,
    this.height,
  });

  final AdsManager adsManager;
  final LinkModel link;
  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        adsManager.showRewardedAd();
        Navigator.of(context).pushNamed(
          AppRoutes.linkDetailsRoute,
          arguments: {'link': link},
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(4, 0, 16.0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: ColorsManager.card,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 25,
              child: Image.asset(
                'assets/images/${link.type.toLowerCase()}.png',
                width: 35,
                height: 35,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    link.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(link.createDt.formatTimeAgoString())
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Text('${link.views}'),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.visibility,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
