import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkati/features/challenges/data/models/question_model.dart';
import 'package:linkati/features/challenges/data/models/topic_model.dart';

import '../models/game_model.dart';

abstract class ChallengesDatasources {
  // questions
  Future<String> createQuestion(QuestionModel question);
  Future<List<QuestionModel>> fetchQuestions(String topic);
  Future<String> updateQuestion(QuestionModel question);
  // games
  Future<String> createGame(GameModel session);
  // topics
  Future<String> createTopic(TopicModel topic);
  Future<String> updateTopic(TopicModel topic);
  Future<List<TopicModel>> fetchTopics();
}

class ChallengesDatasourcesImpl implements ChallengesDatasources {
  final CollectionReference questions;
  final CollectionReference games;
  final CollectionReference topics;

  ChallengesDatasourcesImpl({
    required this.questions,
    required this.games,
    required this.topics,
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
  Future<String> createTopic(TopicModel topic) async {
    try {
      final DocumentReference docRef = topics.doc();
      await topics.doc(docRef.id).set(
            topic.toJson(id: docRef.id),
          );
      return 'success';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> createGame(GameModel session) async {
    try {
      // التحقق من وجود لعبة مفتوحة للمستخدم player1
      final existingGameQuery = await games
          .where('player1.user_id', isEqualTo: session.player1.userId)
          .where('ended_at', isNull: true)
          .limit(1)
          .get();

      // إذا كانت هناك لعبة مفتوحة، رفض إنشاء لعبة جديدة
      if (existingGameQuery.docs.isNotEmpty) {
        return throw Exception('You already have an open game.');
      }

      // إنشاء اللعبة الجديدة
      final DocumentReference docRef = games.doc();
      await games.doc(docRef.id).set(
            session.toJson(id: docRef.id),
          );

      return 'success';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateTopic(TopicModel topic) async {
    try {
      await topics.doc(topic.id).update(topic.toJson());
      return 'success';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<QuestionModel>> fetchQuestions(String topic) async {
    try {
      final QuerySnapshot querySnapshot =
          await questions.where('topic', isEqualTo: topic).get();
      final List<QuestionModel> questionsData = querySnapshot.docs
          .map((doc) =>
              QuestionModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return questionsData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateQuestion(QuestionModel question) async {
    try {
      await questions.doc(question.id).update(question.toJson());
      return 'success';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TopicModel>> fetchTopics() async {
    try {
      final QuerySnapshot querySnapshot = await topics.get();
      final List<TopicModel> topicsData = querySnapshot.docs
          .map((doc) => TopicModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return topicsData;
    } catch (e) {
      rethrow;
    }
  }
}
