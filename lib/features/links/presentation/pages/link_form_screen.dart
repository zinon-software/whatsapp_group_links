import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/features/links/presentation/cubit/links_cubit.dart';

import '../../../../core/ads/ads_manager.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/link_model.dart';

class LinkFormScreen extends StatefulWidget {
  const LinkFormScreen({super.key});

  @override
  State<LinkFormScreen> createState() => _LinkFormScreenState();
}

class _LinkFormScreenState extends State<LinkFormScreen> {
  late final LinksCubit _linksCubit;

  late final TextEditingController _titleController;
  late final TextEditingController _urlController;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Added form key

  late AdsManager _adsManager; // إضافة المتغير هنا

  @override
  void initState() {
    _linksCubit = context.read<LinksCubit>();
    super.initState();

    _titleController = TextEditingController();
    _urlController = TextEditingController();
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
      body: BlocListener<LinksCubit, LinksState>(
        listener: (context, state) {
          if (state is CreateLinkErrorState) {
            AppAlert.customDialog(
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
            AppAlert.customDialog(
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
                              String type = _linksCubit
                                  .determineType(_urlController.text);
                              LinkModel newLink = LinkModel(
                                id: '',
                                title: _titleController.text,
                                createDt: DateTime.now(),
                                url: _urlController.text.trim(),
                                views: 0,
                                type: type,
                                isActive: true,
                              );

                              _linksCubit.createLink(newLink);
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
      ),
    );
  }
}
