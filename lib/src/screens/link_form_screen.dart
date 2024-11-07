import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:linkati/src/widgets/alert_widget.dart';
import 'package:linkati/src/widgets/custom_button_widget.dart';

import '../managers/ads_manager.dart';
import '../managers/cloud_manager.dart';
import '../models/link_model.dart';
import '../widgets/custom_text_field.dart';

class LinkFormScreen extends StatefulWidget {
  const LinkFormScreen({super.key});

  @override
  State<LinkFormScreen> createState() => _LinkFormScreenState();
}

class _LinkFormScreenState extends State<LinkFormScreen> {
  final CloudManager cloudManager = CloudManager();

  late final TextEditingController _titleController;
  late final TextEditingController _urlController;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Added form key

  late AdsManager _adsManager; // إضافة المتغير هنا

  @override
  void initState() {
    _titleController = TextEditingController();
    _urlController = TextEditingController();
    super.initState();
    _adsManager = AdsManager();
    _adsManager.loadBannerAd(adSize: AdSize.fullBanner);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _adsManager.disposeBannerAds();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة مجموعة جديدة"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: _adsManager.getBannerAdWidget(
                  adSize: AdSize.mediumRectangle,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextField(
                        keyboardType: TextInputType.name,
                        controller: _titleController,
                        labelText: "العنوان",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "يرجى إدخال العنوان";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        keyboardType: TextInputType.url,
                        controller: _urlController,
                        hintText: "الرابط",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "يرجى إدخال الرابط";
                          } else if (!Uri.parse(value).isAbsolute) {
                            return "الرابط غير صحيح";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomButtonWidget(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Create a new social media link
                            String type = determineType(_urlController.text);
                            LinkModel newLink = LinkModel(
                              title: _titleController.text,
                              createDt: DateTime.now(),
                              url: _urlController.text,
                              views: 0,
                              type: type,
                              isActive: false,
                            );

                            AppAlert.loading(context);

                            // Add the link to Firestore
                            await cloudManager.addLink(newLink);
                            // ignore: use_build_context_synchronously
                            // عرض رسالة إعلامية بنجاح الإضافة باستخدام AwesomeDialog
                            AppAlert.customDialog(
                              // ignore: use_build_context_synchronously
                              context,
                              title: "تمت إضافة الرابط بنجاح",
                              subTitle:
                                  "تمت أضافة الرابط بنجاح ألى قاعدة البيانات.",
                              confirmText: "إنشاء رابط جديد",
                              icon: Icons.check,
                              onConfirm: () {
                                _titleController.clear();
                                _urlController.clear();
                              },
                              dismissOn: false,
                              cancelText: "إغلق",
                              onCancel: () {
                                AppAlert.dismissDialog(context);
                                Navigator.pop(context);
                              },
                            );
                          }
                        },
                        label: 'إضافة الرابط',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String determineType(String url) {
    if (url.contains("facebook")) {
      return "facebook";
    } else if (url.contains("twitter") || url.contains("x")) {
      return "twitter";
    } else if (url.contains("whatsapp")) {
      return "whatsapp";
    } else if (url.contains("telegram")) {
      return "telegram";
    } else if (url.contains("instagram")) {
      return "instagram";
    } else if (url.contains("snapchat")) {
      return "snapchat";
    } else if (url.contains("tiktok")) {
      return "tiktok";
    } else if (url.contains("linkedin")) {
      return "linkedin";
    } else {
      return "other";
    }
  }
}
