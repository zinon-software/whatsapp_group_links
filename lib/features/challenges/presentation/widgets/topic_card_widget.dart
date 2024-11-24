import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/ads/ads_manager.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/core/widgets/custom_cached_network_image_widget.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/color_manager.dart';
import '../../data/models/topic_model.dart';

class TopicCardWidget extends StatelessWidget {
  const TopicCardWidget({
    super.key,
    required this.topic,
    required this.usersCubit,
    required this.adsManager,
  });

  final TopicModel topic;
  final UsersCubit usersCubit;
  final AdsManager adsManager;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (usersCubit.currentUser?.country == null) {
          AppAlert.showAlert(
            context,
            subTitle: 'يرجى تحديد دولتك',
            confirmText: 'تحديد الدولة',
            onConfirm: () {
              Navigator.pushNamed(
                context,
                AppRoutes.editAccountRoute,
                arguments: {
                  'user': usersCubit.currentUser,
                  'is_edit': usersCubit.currentUser != null,
                },
              ).then(
                (value) {
                  if (usersCubit.currentUser?.country != null) {
                    adsManager.showInterstitialAd();
                    // ignore: use_build_context_synchronously
                    AppAlert.dismissDialog(context);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamed(
                      AppRoutes.gamesRoute,
                      arguments: {'topic': topic},
                    );
                  }
                },
              );
            },
          );
        } else {
          adsManager.showInterstitialAd();
          Navigator.of(context).pushNamed(
            AppRoutes.gamesRoute,
            arguments: {'topic': topic},
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        height: 120,
        width: double.infinity,
        child: Row(
          children: [
            CustomCachedNetworkImage(
              topic.imageUrl,
              height: 120,
              width: 150,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(topic.title, style: const TextStyle(fontSize: 18)),
                    Text(topic.description),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<UsersCubit, UsersState>(
              bloc: usersCubit,
              builder: (context, state) {
                if (usersCubit.currentUser?.permissions.isAdmin ?? false) {
                  return InkWell(
                    onTap: () {
                      AppAlert.showAlertWidget(
                        context,
                        child: Column(
                          children: [
                            Text(
                              topic.title,
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text("${topic.questionCount} سؤال"),
                            SizedBox(height: 10),
                            CustomButtonWidget(
                              width: double.infinity,
                              onPressed: () {
                                AppAlert.dismissDialog(context);
                                Navigator.of(context).pushNamed(
                                  AppRoutes.topicFormRoute,
                                  arguments: {'topic': topic},
                                );
                              },
                              label: "تعديل",
                            ),
                            SizedBox(height: 10),
                            // questionsRoute
                            CustomButtonWidget(
                              width: double.infinity,
                              onPressed: () {
                                AppAlert.dismissDialog(context);
                                Navigator.of(context).pushNamed(
                                  AppRoutes.questionsRoute,
                                  arguments: {'topic': topic},
                                );
                              },
                              label: "الاسئلة",
                            ),
                            SizedBox(height: 10),
                            CustomButtonWidget(
                              width: double.infinity,
                              onPressed: () {
                                AppAlert.dismissDialog(context);
                                Navigator.of(context).pushNamed(
                                  AppRoutes.gamesRoute,
                                  arguments: {'topic': topic},
                                );
                              },
                              label: "المشاركة في التحدي",
                            ),

                            SizedBox(height: 10),
                            CustomButtonWidget(
                              width: double.infinity,
                              onPressed: () {
                                AppAlert.dismissDialog(context);
                                // usersCubit.deleteTopicEvent(topic.id);
                              },
                              label: "حذف",
                              backgroundColor: Colors.red,
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      height: 110,
                      width: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: ColorsManager.card,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 110,
                    width: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: ColorsManager.card,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
