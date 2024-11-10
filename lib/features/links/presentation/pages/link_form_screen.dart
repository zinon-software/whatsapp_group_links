import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/features/links/presentation/cubit/links_cubit.dart';

import '../../../../core/ads/ads_manager.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/link_model.dart';

class LinkFormScreen extends StatefulWidget {
  const LinkFormScreen({super.key, this.link});
  final LinkModel? link;

  @override
  State<LinkFormScreen> createState() => _LinkFormScreenState();
}

class _LinkFormScreenState extends State<LinkFormScreen> {
  late final LinksCubit _linksCubit;

  late final TextEditingController _titleController;
  late final TextEditingController _urlController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AdsManager _adsManager; // إضافة المتغير هنا

  @override
  void initState() {
    _linksCubit = context.read<LinksCubit>();
    super.initState();

    _titleController = TextEditingController();
    _urlController = TextEditingController();
    _adsManager = AdsManager();
    _adsManager.loadBannerAd(adSize: AdSize.fullBanner);
    if (widget.link != null) {
      _titleController.text = widget.link!.title;
      _urlController.text = widget.link!.url;
    }
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
      body: BlocListener<LinksCubit, LinksState>(
        listener: (context, state) {
          if (state is CreateLinkErrorState) {
            AppAlert.showAlert(
              context,
              title: "خطاء في اضافة الرابط",
              subTitle: state.message,
              icon: Icons.error,
              iconColor: Colors.red,
              cancelText: "إغلق",
            );
          }

          if (state is CreateLinkLoadingState) {
            AppAlert.loading(context);
          }

          if (state is CreateLinkSuccessState) {
            AppAlert.showAlert(
              context,
              title: "تمت إضافة الرابط بنجاح",
              subTitle: "تمت أضافة الرابط بنجاح ألى قاعدة البيانات.",
              confirmText: "إنشاء رابط جديد",
              icon: Icons.check,
              iconColor: Colors.green,
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
        child: SingleChildScrollView(
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
                        // Title
                        Text(
                          "اضافة رابط جديد",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
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
                        const SizedBox(height: 16),
                        Text(
                          "بالنقر على ${widget.link == null ? "اضافة" : "تعديل"} ، فأنت توافق على",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.privacyPolicyRoute,
                            );
                          },
                          child: const Text(
                            'سياسة الخصوصية',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        CustomButtonWidget(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Create a new social media link
                              String type = _linksCubit
                                  .determinePlatform(_urlController.text);
                              LinkModel newLink = LinkModel(
                                id: widget.link?.id ?? '',
                                title: _titleController.text,
                                createDt:
                                    widget.link?.createDt ?? DateTime.now(),
                                url: _urlController.text.trim(),
                                views: widget.link?.views ?? 0,
                                type: type,
                                isActive: widget.link?.isActive ?? true,
                              );

                              if (widget.link != null) {
                                _linksCubit.updateLink(newLink);
                              } else {
                                _linksCubit.createLink(newLink.copyWith(
                                  user: FirebaseAuth.instance.currentUser?.uid,
                                ));
                              }
                            }
                          },
                          label: widget.link != null
                              ? 'تحديث الرابط'
                              : 'إضافة الرابط',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
