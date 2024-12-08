import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:linkati/core/routes/app_routes.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/features/links/data/models/link_model.dart';
import 'package:linkati/features/links/presentation/cubit/links_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/app_injector.dart';
import '../../../../core/ads/ads_manager.dart';
import '../../../../core/widgets/alert_widget.dart';
import '../../../users/presentation/cubit/users_cubit.dart';
import '../../../users/presentation/widgets/user_widget.dart';

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
    bool isAdmin =
        instance<UsersCubit>().currentUser?.permissions.isAdmin ?? false;
    return Scaffold(
      appBar: AppBar(
        title: (widget.link.user != null)
            ? LoadUserWidget(
                userId: widget.link.user ?? '',
                query: widget.link.id,
              )
            : Text(widget.link.title),
        actions: [
          // if (!widget.link.isVerified)
          if (isAdmin)
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
                        AppRoutes.addBannedWordsRoute,
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
            Center(
              child: _adsManager.getBannerAdWidget(
                adSize: AdSize.mediumRectangle,
                padding: const EdgeInsets.symmetric(vertical: 20),
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
            if (isAdmin) Text(widget.link.url),
            BlocListener<LinksCubit, LinksState>(
              bloc: _linksCubit,
              listenWhen: (previous, current) =>
                  current is CheckBannedWordLoadingState ||
                  current is CheckBannedWordSuccessState ||
                  current is CheckBannedWordErrorState ||
                  current is ManageLinkLoadingState ||
                  current is ManageLinkSuccessState ||
                  current is ManageLinkErrorState,
              listener: (context, state) {
                if (state is CheckBannedWordErrorState) {
                  AppAlert.showAlert(context, subTitle: state.message);
                }
                if (state is CheckBannedWordLoadingState) {
                  AppAlert.loading(context);
                }
                if (state is CheckBannedWordSuccessState) {
                  AppAlert.dismissDialog(context);
                  launchUrl(Uri.parse(widget.link.url));
                }
                if (state is ManageLinkErrorState) {
                  AppAlert.showAlert(context, subTitle: state.message);
                }
                if (state is ManageLinkLoadingState) {
                  AppAlert.loading(context);
                }
                if (state is ManageLinkSuccessState) {
                  AppAlert.showAlert(
                    context,
                    subTitle: state.message,
                    icon: Icons.check,
                    iconColor: Colors.green,
                  ).then(
                    // ignore: use_build_context_synchronously
                    (value) => Navigator.pop(context),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButtonWidget(
                        onPressed: () async {
                          if (isAdmin) {
                            launchUrl(Uri.parse(widget.link.url));
                          } else if (widget.link.isActive) {
                            _linksCubit.checkBannedWordEvent(
                              widget.link.url.trim().replaceAll('/', ''),
                            );
                          } else {
                            AppAlert.showAlert(
                              context,
                              title: 'الرابط قيد المعالجة',
                              subTitle:
                                  'يجري التاكد من صحة الرابط من قبل الادارة والموافقة علية.',
                            );
                          }
                        },
                        label: 'الانتقال الى ${widget.link.type}',
                      ),
                    ),
                    if (isAdmin)
                      IconButton(
                        onPressed: () {
                          AppAlert.showAlert(
                            context,
                            title: 'حذف رابط',
                            subTitle: 'هل ترغب في حذف هذا الرابط؟',
                            cancelText: 'الغاء',
                            onConfirm: () {
                              _linksCubit.deleteLinkEvent(widget.link.id);
                            },
                          );
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    if (isAdmin)
                      IconButton(
                        onPressed: () {
                          AppAlert.showAlertWidget(
                            context,
                            child: Column(
                              children: [
                                CustomButtonWidget(
                                  width: double.infinity,
                                  height: 50,
                                  onPressed: () {
                                    _linksCubit.changeLinkActiveEvent(
                                      widget.link.id,
                                      !widget.link.isActive,
                                    );
                                  },
                                  label: widget.link.isActive
                                      ? 'الغاء تفعيل الرابط'
                                      : 'تفعيل الرابط',
                                ),
                                SizedBox(height: 10),
                                // edit
                                CustomButtonWidget(
                                  width: double.infinity,
                                  height: 50,
                                  backgroundColor: Colors.green,
                                  onPressed: () {
                                    AppAlert.dismissDialog(context);
                                    Navigator.of(context).pushNamed(
                                      AppRoutes.linkFormRoute,
                                      arguments: {'link': widget.link},
                                    );
                                  },
                                  label: 'تعديل الرابط',
                                ),
                                SizedBox(height: 10),
                                // Verified
                                CustomButtonWidget(
                                  width: double.infinity,
                                  height: 50,
                                  backgroundColor: Colors.green,
                                  onPressed: () {
                                    AppAlert.dismissDialog(context);
                                    _linksCubit.updateLinkEvent(
                                      widget.link.copyWith(isVerified: true),
                                    );
                                  },
                                  label: 'تأكيد الرابط',
                                ),
                                SizedBox(height: 10),
                                // delete
                                CustomButtonWidget(
                                  width: double.infinity,
                                  height: 50,
                                  backgroundColor: Colors.red,
                                  onPressed: () {
                                    _linksCubit.deleteLinkEvent(widget.link.id);
                                  },
                                  label: 'حذف الرابط',
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.more_vert_rounded,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
