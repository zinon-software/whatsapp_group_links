import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/core/widgets/custom_cached_network_image_widget.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../../../core/routes/app_routes.dart';
import '../../data/models/topic_model.dart';

class TopicCardWidget extends StatelessWidget {
  const TopicCardWidget({
    super.key,
    required this.topic,
    required this.usersCubit,
  });

  final TopicModel topic;
  final UsersCubit usersCubit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.gamesRoute,
          arguments: {'topic': topic},
        );
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
                    BlocBuilder<UsersCubit, UsersState>(
                      bloc: usersCubit,
                      builder: (context, state) {
                        if (usersCubit.currentUser?.permissions.isAdmin ??
                            false) {
                          return Expanded(
                            child: CustomButtonWidget(
                              width: double.infinity,
                              icon: Icons.more_vert,
                              label: "أدوات",
                              onPressed: () {
                                AppAlert.showAlertWidget(
                                  context,
                                  child: Column(
                                    children: [
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
                                            arguments: {'topic': topic.id},
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
                            ),
                          );
                        } else {
                          return Expanded(
                            child: CustomButtonWidget(
                              width: double.infinity,
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.gamesRoute,
                                  arguments: {'topic': topic},
                                );
                              },
                              label: "المشاركة في التحدي",
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
