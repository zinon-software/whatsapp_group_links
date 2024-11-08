import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/link_model.dart';

abstract class LinksDatasources {
  // links
  Future<String> createLink(LinkModel link);
  Future<String> incrementViews(String id);
  Future<List<LinkModel>> fetchLinks();
  Future<String> deleteLink(String id);
  Future<String> updateLink(LinkModel link);
  Future<String> activateLink(String id);

  // banned words
  Future<String> addBannedWord(String word);
  Future<List<String>> fetchBannedWords();
  Future<String> deleteBannedWord(String word);
}

class LinksDatasourcesImpl implements LinksDatasources {
  final CollectionReference links;
  final CollectionReference bannedWords;

  LinksDatasourcesImpl({required this.links, required this.bannedWords});

  @override
  Future<String> createLink(LinkModel link) async {
    try {
      // check if link name is not banned
      final List<String> bannedWordsData = await fetchBannedWords();

      if (bannedWordsData.contains(link.title)) {
        return throw Exception("تم حظر نشر الرابط بسبب مخالفتك لسياسة النشر");
      }
      final DocumentReference linkDocRef = links.doc();

      await links.doc(linkDocRef.id).set(link.toJson(id: linkDocRef.id));
      return 'Link added successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> activateLink(String id) async {
    try {
      await links.doc(id).update({'is_active': true});
      return 'Link activated successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteLink(String id) async {
    try {
      await links.doc(id).delete();
      return 'Link deleted successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<LinkModel>> fetchLinks() async {
    try {
      final QuerySnapshot querySnapshot = await links.get();
      final List<LinkModel> linksData = querySnapshot.docs
          .map((doc) => LinkModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return linksData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> incrementViews(String id) async {
    try {
      final DocumentReference linkDocRef = links.doc(id);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final DocumentSnapshot linkSnapshot = await transaction.get(linkDocRef);

        if (linkSnapshot.exists) {
          final int currentViews = linkSnapshot['views'];
          transaction.update(linkDocRef, {'views': currentViews + 1});
        }
      });

      return 'Views incremented successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateLink(LinkModel link) async {
    try {
      await links.doc(link.id).update(link.toJson());
      return 'Link updated successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> addBannedWord(String word) async {
    try {
      await bannedWords.doc(word).set(word);
      return 'Word added successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteBannedWord(String word) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return 'You must be logged in to delete a banned word';
    }

    try {
      await bannedWords.doc(word).delete();
      return 'Word deleted successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> fetchBannedWords() async {
    try {
      final QuerySnapshot querySnapshot = await bannedWords.get();
      final List<String> bannedWordsData =
          querySnapshot.docs.map((doc) => doc.data() as String).toList();
      return bannedWordsData;
    } catch (e) {
      rethrow;
    }
  }
}
