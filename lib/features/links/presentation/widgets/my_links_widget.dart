import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/core/api/app_collections.dart';

import '../../../../core/widgets/custom_skeletonizer_widget.dart';
import '../../data/models/link_model.dart';
import 'link_card_widget.dart';

class MyLinksWidget extends StatelessWidget {
  const MyLinksWidget({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<LinkModel>(
      pageSize: 20,
      query: instance<AppCollections>()
          .links
          .where('user', isEqualTo: userId)
          .withConverter<LinkModel>(
            fromFirestore: (snapshot, _) => LinkModel.fromJson(
              snapshot.data() as Map<String, dynamic>,
            ),
            toFirestore: (link, _) => link.toJson(),
          ),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return CustomSkeletonizerWidget(
            enabled: true,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Column(
                children: [
                  LinkCardWidget(
                    link: LinkModel.isEmpty(),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              itemCount: 4,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.docs.isEmpty) {
          return const Center(
            child: Text('No social media links available.'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.docs.length,
          itemBuilder: (context, index) {
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              // Tell FirestoreQueryBuilder to try to obtain more items.
              // It is safe to call this function from within the build method.
              snapshot.fetchMore();
            }

            final LinkModel link = snapshot.docs[index].data();

            return Column(
              children: [
                LinkCardWidget(link: link),
                SizedBox(height: 10),
              ],
            );
          },
        );
      },
    );
  }
}
