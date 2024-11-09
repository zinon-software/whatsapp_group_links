import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkati/features/challenges/data/models/question_model.dart';
import 'package:linkati/features/challenges/data/models/section_model.dart';
import 'package:linkati/features/challenges/data/models/session_model.dart';

abstract class ChallengesDatasources {
  // questions
  Future<String> createQuestion(QuestionModel question);
  // sessions
  Future<String> createSession(SessionModel session);
  // sections
  Future<String> createSection(SectionModel section);
}

class ChallengesDatasourcesImpl implements ChallengesDatasources {
  final CollectionReference questions;
  final CollectionReference sessions;
  final CollectionReference sections;

  ChallengesDatasourcesImpl({
    required this.questions,
    required this.sessions,
    required this.sections,
  });

  @override
  Future<String> createQuestion(QuestionModel question) async {
    try {
      final DocumentReference docRef = questions.doc();

      await questions.doc(docRef.id).set(
            question.toJson(id: docRef.id),
          );
      return 'success';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> createSection(SectionModel section) async {
    try {
      final DocumentReference docRef = sections.doc();
      await sections.doc(docRef.id).set(
            section.toJson(id: docRef.id),
          );
      return 'success';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> createSession(SessionModel session) async {
    try {
      final DocumentReference docRef = sessions.doc();
      await sessions.doc(docRef.id).set(
            session.toJson(id: docRef.id),
          );
      return 'success';
    } catch (e) {
      rethrow;
    }
  }
}
