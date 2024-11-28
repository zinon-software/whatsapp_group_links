import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/link_model.dart';

abstract class LinksDatasources {
  // links
  Future<LinkModel> createLink(LinkModel link);
  Future<String> incrementViews(String id);
  Future<List<LinkModel>> fetchLinks();
  Future<String> deleteLink(String id);
  Future<String> updateLink(LinkModel link);
  Future<String> changeLinkActive(String id, bool isActive);

  // banned words
  Future<String> createBannedWord(String word);
  Future<List<String>> fetchBannedWords();
  Future<String> deleteBannedWord(String word);
  Future<bool> checkBannedWord(String word);
}

class LinksDatasourcesImpl implements LinksDatasources {
  final CollectionReference links;
  final CollectionReference bannedWords;

  LinksDatasourcesImpl({required this.links, required this.bannedWords});

  @override
  Future<LinkModel> createLink(LinkModel link) async {
    try {
      // check if link name is not banned
      final List<String> bannedWordsData = await fetchBannedWords();

      List<String> titleWords = link.title.split(' ');
      for (String word in titleWords) {
        if (bannedWordsData.contains(word)) {
          return throw Exception("تم حظر نشر الرابط بسبب مخالفتك لسياسة النشر");
        }
      }

      if (bannedWordsData.contains(link.url)) {
        return throw Exception("تم حظر نشر الرابط بسبب مخالفتك لسياسة النشر");
      }

      final DocumentReference linkDocRef = links.doc();

      link = link.copyWith(id: linkDocRef.id);

      await links.doc(linkDocRef.id).set(link.toJson());
      return link;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> changeLinkActive(String id, bool isActive) async {
    try {
      await links.doc(id).update({'is_active': isActive});
      return 'تم تحديث الرابط بنجاح';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteLink(String id) async {
    try {
      await links.doc(id).delete();
      return 'تم حذف الرابط بنجاح';
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

      return 'تم تحديث الرابط بنجاح';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateLink(LinkModel link) async {
    try {
      final List<String> bannedWordsData = await fetchBannedWords();

      List<String> titleWords = link.title.split(' ');
      for (String word in titleWords) {
        if (bannedWordsData.contains(word)) {
          return throw Exception("تم حظر نشر الرابط بسبب مخالفتك لسياسة النشر");
        }
      }

      await links.doc(link.id).update(link.toJson());
      return 'تم تحديث الرابط بنجاح';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> createBannedWord(String word) async {
    try {
      await bannedWords.doc(word).set({'word': word});
      return 'تم حفظ الكلمة بنجاح';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteBannedWord(String word) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return 'انت غير مسجل دخول';
    }

    try {
      await bannedWords.doc(word).delete();
      return 'تم حذف الكلمة بنجاح';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> fetchBannedWords() async {
    try {
      final QuerySnapshot querySnapshot = await bannedWords.get();
      final List<String> bannedWordsData =
          querySnapshot.docs.map((doc) => doc['word'] as String).toList();
      return bannedWordsData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> checkBannedWord(String word) async {
    try {
      final DocumentSnapshot querySnapshot = await bannedWords.doc(word).get();
      return querySnapshot.exists;
    } catch (e) {
      rethrow;
    }
  }
}
