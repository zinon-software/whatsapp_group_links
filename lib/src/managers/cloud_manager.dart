import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/links/data/models/link_model.dart';

class CloudManager {
  final CollectionReference linksCollection =
      FirebaseFirestore.instance.collection('social_media_links');

  Future<void> addLink(LinkModel link) async {
    try {
      await linksCollection.add(link.toJson());
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

  

  String determineType(String url) {
    if (url.contains("facebook")) {
      return "facebook";
    } else if (url.contains("twitter") || url.contains("x")) {
      return "twitter";
    } else if (url.contains("whatsapp")) {
      return "whatsapp";
    } else if (url.contains("telegram")) {
      return "telegram";
    } else if (url.contains("instagram")) {
      return "instagram";
    } else if (url.contains("snapchat")) {
      return "snapchat";
    } else if (url.contains("tiktok")) {
      return "tiktok";
    } else if (url.contains("linkedin")) {
      return "linkedin";
    } else {
      return "other";
    }
  }
}


