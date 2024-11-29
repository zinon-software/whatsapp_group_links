import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/features/links/data/datasources/links_datasources.dart';

import '../../../../core/notification/notification_manager.dart';
import '../models/qna_answer_model.dart';
import '../models/qna_question_model.dart';

abstract class QnaDatasources {
  // qnaQuestions
  Future<String> createQuestion(QnaQuestionModel link);
  Future<String> incrementAnswersCount(String id);
  Future<List<QnaQuestionModel>> fetchQnaQuestions();
  Future<QnaQuestionModel> fetchQnaQuestion(String questionId);
  Future<String> deleteQuestion(String id);
  Future<String> updateQuestion(QnaQuestionModel question);
  Future<String> changeQuestionActive(String id, bool isActive);

  // qnaAnswers
  Future<String> createAnswer(QnaAnswerModel answer);
  Future<String> updateAnswer(QnaAnswerModel answer);
  Future<String> deleteAnswer(String id);
  Future<String> incrementAnswerVotes(String id);
  Future<String> decrementAnswerVotes(String id);
  Future<List<QnaAnswerModel>> fetchQnaAnswers(String questionId);
}

class QnaDatasourcesImpl implements QnaDatasources {
  final CollectionReference questions;
  final CollectionReference answers;

  QnaDatasourcesImpl({required this.questions, required this.answers});

  @override
  Future<String> createQuestion(QnaQuestionModel question) async {
    try {
      final LinksDatasources linksDatasources = instance<LinksDatasources>();

      final List<String> bannedWordsData =
          await linksDatasources.fetchBannedWords();

      List<String> titleWords = question.text.split(' ');
      for (String word in titleWords) {
        if (bannedWordsData.contains(word)) {
          return throw Exception("تم حظر النشر بسبب مخالفتك لسياسة النشر");
        }
      }

      final DocumentReference docRef = questions.doc();

      question = question.copyWith(id: docRef.id);

      await docRef.set(question.toJson());

      NotificationManager.subscribeToTopic(question.id);

      return 'Link added successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> changeQuestionActive(String id, bool isActive) async {
    try {
      await questions.doc(id).update({'is_active': isActive});
      return 'question activated successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteQuestion(String id) async {
    try {
      await questions.doc(id).delete();

      answers.where('question_id', isEqualTo: id).get().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      NotificationManager.unSubscribeToTopic(id);

      return 'Link deleted successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<QnaQuestionModel>> fetchQnaQuestions() async {
    try {
      final QuerySnapshot querySnapshot = await questions.get();
      final List<QnaQuestionModel> qnaData = querySnapshot.docs
          .map((doc) =>
              QnaQuestionModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return qnaData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> incrementAnswersCount(String id) async {
    try {
      final DocumentReference docRef = questions.doc(id);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final DocumentSnapshot answersCountSnapshot =
            await transaction.get(docRef);

        if (answersCountSnapshot.exists) {
          final int currentCount = answersCountSnapshot['answers_count'];
          transaction.update(docRef, {'answers_count': currentCount + 1});
        }
      });

      return 'Answers count incremented successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateQuestion(QnaQuestionModel question) async {
    try {
      final LinksDatasources linksDatasources = instance<LinksDatasources>();

      final List<String> bannedWordsData =
          await linksDatasources.fetchBannedWords();

      List<String> titleWords = question.text.split(' ');
      for (String word in titleWords) {
        if (bannedWordsData.contains(word)) {
          return throw Exception("تم حظر النشر بسبب مخالفتك لسياسة النشر");
        }
      }

      await questions.doc(question.id).update(question.toJson());
      return 'question updated successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> createAnswer(QnaAnswerModel answer) async {
    try {
      final LinksDatasources linksDatasources = instance<LinksDatasources>();

      final List<String> bannedWordsData =
          await linksDatasources.fetchBannedWords();

      List<String> titleWords = answer.text.split(' ');
      for (String word in titleWords) {
        if (bannedWordsData.contains(word)) {
          return throw Exception("تم حظر النشر بسبب مخالفتك لسياسة النشر");
        }
      }

      final DocumentReference docRef = answers.doc();
      answer = answer.copyWith(id: docRef.id);
      await docRef.set(answer.toJson());
      incrementAnswersCount(answer.questionId);
      return 'answer added successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> decrementAnswerVotes(String id) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final DocumentSnapshot answerSnapshot =
            await transaction.get(answers.doc(id));

        if (answerSnapshot.exists) {
          final int currentVotes = answerSnapshot['votes'];
          transaction.update(answers.doc(id), {'votes': currentVotes - 1});
        }
      });
      return 'answer votes decremented successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteAnswer(String id) async {
    try {
      await answers.doc(id).delete();
      return 'answer deleted successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<QnaAnswerModel>> fetchQnaAnswers(String questionId) async {
    try {
      final QuerySnapshot querySnapshot =
          await answers.where('question_id', isEqualTo: questionId).get();
      final List<QnaAnswerModel> qnaData = querySnapshot.docs
          .map((doc) =>
              QnaAnswerModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return qnaData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> incrementAnswerVotes(String id) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final DocumentSnapshot answerSnapshot =
            await transaction.get(answers.doc(id));

        if (answerSnapshot.exists) {
          final int currentVotes = answerSnapshot['votes'];
          transaction.update(answers.doc(id), {'votes': currentVotes + 1});
        }
      });
      return 'answer votes incremented successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateAnswer(QnaAnswerModel answer) async {
    try {
      final LinksDatasources linksDatasources = instance<LinksDatasources>();

      final List<String> bannedWordsData =
          await linksDatasources.fetchBannedWords();

      List<String> titleWords = answer.text.split(' ');
      for (String word in titleWords) {
        if (bannedWordsData.contains(word)) {
          return throw Exception("تم حظر النشر بسبب مخالفتك لسياسة النشر");
        }
      }

      await answers.doc(answer.id).update(answer.toJson());
      return 'answer updated successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QnaQuestionModel> fetchQnaQuestion(String questionId) async {
    try {
      final DocumentSnapshot questionSnapshot =
          await questions.doc(questionId).get();
      if (!questionSnapshot.exists) {
        throw Exception('Question not found');
      }
      final QnaQuestionModel qnaData = QnaQuestionModel.fromJson(
        questionSnapshot.data() as Map<String, dynamic>,
      );
      return qnaData;
    } catch (e) {
      rethrow;
    }
  }
}
