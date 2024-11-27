import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkati/core/extensions/date_format_extension.dart';
import 'package:linkati/core/utils/color_manager.dart';

import '../../../../core/ads/ads_manager.dart';
import '../../../../core/routes/app_routes.dart';
import '../../data/models/link_model.dart';

class LinkCardWidget extends StatelessWidget {
  const LinkCardWidget({
    super.key,
    this.adsManager,
    required this.link,
    this.width = double.infinity,
    this.height,
  });

  final AdsManager? adsManager;
  final LinkModel link;
  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (link.isVIP) {
          adsManager?.showRewardedAd();
        } else {
          adsManager?.showInterstitialAd();
        }

        Navigator.of(context).pushNamed(
          AppRoutes.linkDetailsRoute,
          arguments: {'link': link},
        );
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(4, 0, 16.0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            width: width.w,
            height: height?.h,
            decoration: BoxDecoration(
              color: link.isVIP
                  ? ColorsManager.vipCard
                  : link.isAd
                      ? ColorsManager.adCard
                      : ColorsManager.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: link.isVIP
                    ? ColorsManager.vipBorder
                    : link.isAd
                        ? ColorsManager.adBorder
                        : Colors.transparent,
                width: 2,
              ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          if (link.isAd)
            Positioned(
              top: 0,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: const Text(
                  'Ad',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (link.isVIP)
            Positioned(
              top: 0,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: const Text(
                  'VIP',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
