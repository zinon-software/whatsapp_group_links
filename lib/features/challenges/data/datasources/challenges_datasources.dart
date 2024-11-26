import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkati/features/challenges/data/models/question_model.dart';
import 'package:linkati/features/challenges/data/models/topic_model.dart';

import '../models/game_model.dart';

abstract class ChallengesDatasources {
  // questions
  Future<String> createQuestion(QuestionModel question);
  Future<List<QuestionModel>> fetchQuestions(String topic);
  Future<String> updateQuestion(QuestionModel question);
  Future<String> deleteQuestion(QuestionModel question);
  // games
  Future<GameModel> createGame(GameModel game);
  Future<GameModel> joinGameEvent(GameModel game);
  Future<GameModel> startGameWithAi(GameModel game);
  Future<GameModel> endGameEvent(GameModel game);
  Future<GameModel> updateGame(GameModel game);
  Future<String> deleteGame(String id);
  // topics
  Future<String> createTopic(TopicModel topic);
  Future<String> updateTopic(TopicModel topic);
  Future<List<TopicModel>> fetchTopics();
  Future<TopicModel> fetchTopic(String topicId);
  Future<String> incrementTopicQuestionCount(String topic);
  Future<String> decrementTopicQuestionCount(String topic);
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

      await questions.doc(docRef.id).set(question.toJson(id: docRef.id));

      incrementTopicQuestionCount(question.topic);

      return 'success';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> createTopic(TopicModel topic) async {
    try {
      final DocumentReference docRef = topics.doc();
      await topics.doc(docRef.id).set(topic.toJson(id: docRef.id));
      return 'success';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GameModel> createGame(GameModel game) async {
    try {
      // التحقق من وجود لعبة مفتوحة للمستخدم player1
      final existingGameQuery = await games
          .where('player1.user_id', isEqualTo: game.player1.userId)
          .where('ended_at', isNull: true)
          .limit(1)
          .get();

      // إذا كانت هناك لعبة مفتوحة، رفض إنشاء لعبة جديدة
      if (existingGameQuery.docs.isNotEmpty) {
        return GameModel.fromJson(
          existingGameQuery.docs.first.data() as Map<String, dynamic>,
        );
      }

      // إنشاء اللعبة الجديدة
      final DocumentReference docRef = games.doc();
      game = game.copyWith(id: docRef.id);
      await games.doc(docRef.id).set(game.toJson());

      return game;
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

  @override
  Future<TopicModel> fetchTopic(String topicId) async {
    try {
      final DocumentSnapshot documentSnapshot = await topics.doc(topicId).get();
      if (!documentSnapshot.exists) {
        return throw Exception('Topic not found');
      }
      return TopicModel.fromJson(
        documentSnapshot.data() as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GameModel> joinGameEvent(GameModel game) async {
    try {
      await games.doc(game.id).update(game.toJson());
      return game;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GameModel> endGameEvent(GameModel game) async {
    try {
      await games.doc(game.id).update(game.toJson());
      return game;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GameModel> startGameWithAi(GameModel game) async {
    try {
      await games.doc(game.id).update(game.toJson());
      return game;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GameModel> updateGame(GameModel game) async {
    try {
      await games.doc(game.id).update(game.toJson());
      return game;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteGame(String id) async {
    try {
      // check if the game exists
      final doc = await games.doc(id).get();
      if (!doc.exists) {
        return 'Game not found';
      }
      await doc.reference.delete();
      return 'success';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> incrementTopicQuestionCount(String topic) async {
    try {
      TopicModel topicModel = await fetchTopic(topic);

      await updateTopic(
        topicModel.copyWith(questionCount: topicModel.questionCount + 1),
      );

      return 'success';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> decrementTopicQuestionCount(String topic) async {
    try {
      TopicModel topicModel = await fetchTopic(topic);

      await updateTopic(
          topicModel.copyWith(questionCount: topicModel.questionCount - 1));
      return 'success';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteQuestion(QuestionModel question) async {
    try {
      await questions.doc(question.id).delete();
      decrementTopicQuestionCount(question.topic);
      return 'success';
    } catch (e) {
      rethrow;
    }
  }
}
