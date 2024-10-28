import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:linkati/src/models/social_media_link.dart';
import 'package:linkati/src/widgets/custom_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../managers/ads_manager.dart';
import '../managers/cloud_manager.dart';

class MediaLinkDetailScreen extends StatefulWidget {
  const MediaLinkDetailScreen({super.key, required this.socialMediaLink});

  final SocialMediaLink socialMediaLink;

  @override
  State<MediaLinkDetailScreen> createState() => _MediaLinkDetailScreenState();
}

class _MediaLinkDetailScreenState extends State<MediaLinkDetailScreen> {
  late AdsManager _adsManager;

  @override
  void initState() {
    super.initState();
    _adsManager = AdsManager();
    _adsManager.loadBannerAd(adSize: AdSize.fullBanner);
  }

  @override
  void dispose() {
    _adsManager.disposeBannerAds();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CloudManager cloudManager = CloudManager();
    cloudManager.incrementViews(widget.socialMediaLink.documentId ?? '');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.socialMediaLink.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: _adsManager.getBannerAdWidget(
                  adSize: AdSize.mediumRectangle,
                ),
              ),
            ),
            // اضف اعلانك هنا لاكثر من 200 الف مستخدم write code ui

            const SizedBox(height: 10),
            Text(
              widget.socialMediaLink.title,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),

            Spacer(),
            CustomButtonWidget(
              onPressed: () async {
                if (widget.socialMediaLink.isActive) {
                  launchUrl(Uri.parse(widget.socialMediaLink.url));
                } else {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.bottomSlide,
                    title: 'الرابط قيد المعالجة',
                    desc:
                        'يجري التاكد من صحة الرابط من قبل الادارة والموافقة علية.',
                    btnCancelOnPress: () {},
                    btnCancelText: "إغلاق",
                  ).show();
                }
              },
              label: 'الانتقال الى ${widget.socialMediaLink.type}',
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
