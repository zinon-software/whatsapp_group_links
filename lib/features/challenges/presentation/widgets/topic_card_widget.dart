import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
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
  });

  final TopicModel topic;
  final UsersCubit usersCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorManager.primaryLight,
          width: 2,
        ),
      ),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ListTile(
        leading: CustomCachedNetworkImage(
          topic.imageUrl,
          height: 50,
          width: 50,
        ),
        title: Text(topic.title),
        subtitle: Text(topic.description),
        trailing: BlocBuilder<UsersCubit, UsersState>(
          bloc: usersCubit,
          builder: (context, state) {
            if (usersCubit.currentUser?.permissions.isAdmin ?? false) {
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
                            Navigator.of(context).pushNamed(
                              AppRoutes.questionsRoute,
                              arguments: {'topic': topic.id},
                            );
                          },
                          child: const Text("الاسئلة"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.gamesRoute,
                              arguments: {'topic': topic.id},
                            );
                          },
                          child: const Text("المشاركة في التحدي"),
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
      ),
    );
  }
}
