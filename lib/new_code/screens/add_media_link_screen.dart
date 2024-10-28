import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../managers/ads_manager.dart';
import '../managers/cloud_manager.dart';
import '../models/social_media_link.dart';

class AddMediaLinkScreen extends StatefulWidget {
  const AddMediaLinkScreen({super.key});

  @override
  State<AddMediaLinkScreen> createState() => _AddMediaLinkScreenState();
}

class _AddMediaLinkScreenState extends State<AddMediaLinkScreen> {
  final CloudManager cloudManager = CloudManager();

  late final TextEditingController titleController = TextEditingController();
  late final TextEditingController urlController = TextEditingController();
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Added form key

  late AdsManager _adsManager; // إضافة المتغير هنا

  @override
  void initState() {
    super.initState();
    _adsManager = AdsManager();
    _adsManager.loadBannerAd(adSize: AdSize.fullBanner);
  }

  @override
  void dispose() {
    titleController.dispose();
    urlController.dispose();
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
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "العنوان",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "يرجى إدخال العنوان";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.url,
                        controller: urlController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "الرابط",
                        ),
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
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Create a new social media link
                            String type = determineType(urlController.text);
                            SocialMediaLink newLink = SocialMediaLink(
                              title: titleController.text,
                              createDt: DateTime.now(),
                              url: urlController.text,
                              views: 0,
                              type: type,
                              isActive: false,
                            );

                            showAdaptiveDialog(
                              context: context,
                              builder: (context) => const CupertinoAlertDialog(
                                content: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            );

                            // Add the link to Firestore
                            await cloudManager.addSocialMediaLink(newLink);
                            Navigator.pop(context);
                            // عرض رسالة إعلامية بنجاح الإضافة باستخدام AwesomeDialog
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.bottomSlide,
                              title: 'تمت الإضافة بنجاح',
                              desc:
                                  'تمت إضافة الرابط بنجاح إلى قاعدة البيانات.',
                              btnCancelOnPress: () {
                                Navigator.pop(context);
                              },
                              btnOkOnPress: () {
                                titleController.clear();
                                urlController.clear();
                              },
                              btnOkText: "إضافة رابط جديد",
                              btnCancelText: "إغلاق",
                              dismissOnTouchOutside: false,
                              dismissOnBackKeyPress: false,
                            ).show();
                          }
                        },
                        child: const Text('إضافة الرابط'),
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
      return "Facebook";
    } else if (url.contains("twitter")) {
      return "Twitter";
    } else if (url.contains("whatsapp")) {
      return "WhatsApp";
    } else {
      return "Other";
    }
  }
}
