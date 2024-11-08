import 'package:cloud_firestore/cloud_firestore.dart';

class AppCollections {
  static final AppCollections _instance = AppCollections._internal();

  factory AppCollections() => _instance;

  AppCollections._internal();

  static AppCollections get instance => _instance;

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get users => _db.collection('users');

  CollectionReference get links =>
      _db.collection('links').doc("links").collection("links");
  CollectionReference get bannedWords =>
      _db.collection('links').doc("banned_words").collection("banned_words");


  CollectionReference get questions =>
      _db.collection('challenges').doc("questions").collection("questions");
  CollectionReference get sessions =>
      _db.collection('challenges').doc("sessions").collection("sessions");

}