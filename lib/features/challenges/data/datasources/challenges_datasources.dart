import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChallengesDatasources {}

class ChallengesDatasourcesImpl implements ChallengesDatasources {
  final CollectionReference questions;
  final CollectionReference sessions;

  ChallengesDatasourcesImpl({required this.questions, required this.sessions});
}
