import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:linkati/features/links/data/models/link_model.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/ads/ads_manager.dart';
import '../../../../src/managers/cloud_manager.dart';

class LinkDetailsScreen extends StatefulWidget {
  const LinkDetailsScreen({super.key, required this.link});

  final LinkModel link;

  @override
  State<LinkDetailsScreen> createState() => _LinkDetailsScreenState();
}

class _LinkDetailsScreenState extends State<LinkDetailsScreen> {
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
    cloudManager.incrementViews(widget.link.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.link.title),
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
              widget.link.title,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Image.asset(
              'assets/images/${widget.link.type.toLowerCase()}.png',
              height: 100,
              width: 100,
            ),
            Text('${widget.link.views} مشاهدة'),

            Spacer(),
            CustomButtonWidget(
              onPressed: () async {
                if (widget.link.isActive) {
                  launchUrl(Uri.parse(widget.link.url));
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
              label: 'الانتقال الى ${widget.link.type}',
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
