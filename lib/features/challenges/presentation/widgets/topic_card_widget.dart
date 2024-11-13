import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
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
          arguments: {'topic': topic.id},
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(topic.title)),
                        BlocBuilder<UsersCubit, UsersState>(
                          bloc: usersCubit,
                          builder: (context, state) {
                            if (usersCubit.currentUser?.permissions.isAdmin ??
                                false) {
                              return IconButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                ),
                                onPressed: () {
                                  AppAlert.showAlertWidget(
                                    context,
                                    child: Column(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            AppAlert.dismissDialog(context);
                                            Navigator.of(context).pushNamed(
                                              AppRoutes.topicFormRoute,
                                              arguments: {'topic': topic},
                                            );
                                          },
                                          child: const Text("تعديل"),
                                        ),
                                        // questionsRoute
                                        TextButton(
                                          onPressed: () {
                                            AppAlert.dismissDialog(context);
                                            Navigator.of(context).pushNamed(
                                              AppRoutes.questionsRoute,
                                              arguments: {'topic': topic.id},
                                            );
                                          },
                                          child: const Text("الاسئلة"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            AppAlert.dismissDialog(context);
                                            Navigator.of(context).pushNamed(
                                              AppRoutes.gamesRoute,
                                              arguments: {'topic': topic.id},
                                            );
                                          },
                                          child:
                                              const Text("المشاركة في التحدي"),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              return TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    AppRoutes.gamesRoute,
                                    arguments: {'topic': topic.id},
                                  );
                                },
                                child: Text("المشاركة في التحدي"),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    Text(topic.description),
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
