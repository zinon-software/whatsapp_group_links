import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/core/extensions/date_format_extension.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';

import '../../../../core/api/app_collections.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/alert_widget.dart';
import '../../data/models/link_model.dart';
import '../cubit/links_cubit.dart';

class LinksDashboardScreen extends StatelessWidget {
  const LinksDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LinksCubit linksCubit = context.read<LinksCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("قائمة المجموعات"),
      ),
      body: BlocListener<LinksCubit, LinksState>(
        bloc: linksCubit,
        listener: (context, state) {
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
            );
          }
        },
        child: FirestoreQueryBuilder<LinkModel>(
          pageSize: 20,
          query: instance<AppCollections>()
              .links
              .orderBy('create_dt', descending: true)
              .withConverter<LinkModel>(
                fromFirestore: (snapshot, _) => LinkModel.fromJson(
                  snapshot.data() as Map<String, dynamic>,
                ),
                toFirestore: (link, _) => link.toJson(),
              ),
          builder: (context, snapshot, _) {
            if (snapshot.isFetching) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.docs.isEmpty) {
              return const Center(
                child: Text('No social media links available.'),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: snapshot.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                    // Tell FirestoreQueryBuilder to try to obtain more items.
                    // It is safe to call this function from within the build method.
                    snapshot.fetchMore();
                  }

                  var link = snapshot.docs[index].data();

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.linkDetailsRoute,
                        arguments: {'link': link},
                      );
                    },
                    child: Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8),
                        leading: Text("${index + 1}"),
                        title: Text(
                          link.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (link.isActive == true)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  CupertinoIcons.checkmark_seal_fill,
                                  color: Colors.green,
                                ),
                              ),
                            Expanded(
                              child: Text(
                                link.createDt.formatTimeAgoString(),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: Text(
                                link.type,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            AppAlert.showAlertWidget(
                              context,
                              child: Column(
                                children: [
                                  CustomButtonWidget(
                                    width: double.infinity,
                                    height: 50,
                                    onPressed: () {
                                      linksCubit.changeLinkActiveEvent(
                                        link.id,
                                        !link.isActive,
                                      );
                                    },
                                    label: link.isActive
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
                                        arguments: {'link': link},
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
                                      linksCubit.updateLinkEvent(
                                        link.copyWith(isVerified: true),
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
                                      linksCubit.deleteLinkEvent(link.id);
                                    },
                                    label: 'حذف الرابط',
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.more_vert),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
