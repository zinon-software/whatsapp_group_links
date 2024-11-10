import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:linkati/core/routes/app_routes.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/features/links/data/models/link_model.dart';
import 'package:linkati/features/links/presentation/cubit/links_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/ads/ads_manager.dart';
import '../../../../core/widgets/alert_widget.dart';

class LinkDetailsScreen extends StatefulWidget {
  const LinkDetailsScreen({super.key, required this.link});

  final LinkModel link;

  @override
  State<LinkDetailsScreen> createState() => _LinkDetailsScreenState();
}

class _LinkDetailsScreenState extends State<LinkDetailsScreen> {
  late final LinksCubit _linksCubit;
  late AdsManager _adsManager;

  @override
  void initState() {
    _linksCubit = context.read<LinksCubit>();
    super.initState();
    _adsManager = AdsManager();
    _adsManager.loadBannerAd(adSize: AdSize.fullBanner);
    _linksCubit.repository.incrementViews(widget.link.id);
  }

  @override
  void dispose() {
    _adsManager.disposeBannerAds();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.link.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                AppAlert.showAlert(
                  context,
                  title: "تبليغ عن محتوى غير لائق",
                  subTitle:
                      "هل ترغب في التبليغ عن محتوى غير لائق في هذا الرابط؟",
                  confirmText: "تقديم بلاغ",
                  onConfirm: () {
                    AppAlert.dismissDialog(context);
                    Navigator.of(context).pushNamed(
                      AppRoutes.bannedWordsRoute,
                      arguments: {
                        'words': widget.link.title.split(' ').toList() +
                            [widget.link.url],
                      },
                    );
                  },
                  cancelText: "الغاء",
                  onCancel: () => AppAlert.dismissDialog(context),
                );
              },
              icon: const Icon(
                Icons.report,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
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
            const SizedBox(height: 10),
            Text(
              widget.link.title,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
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
