import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/link_model.dart';

class CloudManager {
  final CollectionReference linksCollection =
      FirebaseFirestore.instance.collection('social_media_links');

  Future<void> addLink(LinkModel link) async {
    try {
      await linksCollection.add(link.toMap());
      print('Social media link added successfully.');
    } catch (e) {
      print('Error adding social media link: $e');
    }
  }

  Future<void> incrementViews(String documentId) async {
    try {
      final DocumentReference linkDocRef = linksCollection.doc(documentId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final DocumentSnapshot linkSnapshot = await transaction.get(linkDocRef);

        if (linkSnapshot.exists) {
          final int currentViews = linkSnapshot['views'];
          transaction.update(linkDocRef, {'views': currentViews + 1});
        }
      });

      print('Views incremented successfully.');
    } catch (e) {
      print('Error incrementing views: $e');
    }
  }
}
