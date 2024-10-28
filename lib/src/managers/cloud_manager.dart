import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/social_media_link.dart';

class CloudManager {
  final CollectionReference linksCollection =
      FirebaseFirestore.instance.collection('social_media_links');

  Future<void> addSocialMediaLink(SocialMediaLink link) async {
    try {
      await linksCollection.add(link.toMap());
      print('Social media link added successfully.');
    } catch (e) {
      print('Error adding social media link: $e');
    }
  }

  Future<void> incrementViews(String documentId) async {
    print(documentId);
    try {
      final DocumentReference linkDocRef = linksCollection.doc(documentId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final DocumentSnapshot linkSnapshot = await transaction.get(linkDocRef);

        if (linkSnapshot.exists) {
          final int currentViews = linkSnapshot['views'];
          await transaction.update(linkDocRef, {'views': currentViews + 1});
        }
      });

      print('Views incremented successfully.');
    } catch (e) {
      print('Error incrementing views: $e');
    }
  }
}
