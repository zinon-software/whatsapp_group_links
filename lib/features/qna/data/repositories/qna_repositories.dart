import 'package:dartz/dartz.dart';
import 'package:linkati/features/qna/data/models/qna_question_model.dart';

import '../../../../core/api/error_handling.dart';
import '../../../../core/network/connection_status.dart';
import '../datasources/qna_datasources.dart';
import '../models/qna_answer_model.dart';

abstract class QnaRepository {
  // qnaQuestions
  Future<Either<String, String>> createQuestion(QnaQuestionModel question);
  Future<Either<String, String>> incrementAnswersCount(String id);
  Future<Either<String, List<QnaQuestionModel>>> fetchQnaQuestions();
  Future<Either<String, QnaQuestionModel>> fetchQnaQuestion(String questionId);
  Future<Either<String, String>> deleteQuestion(String id);
  Future<Either<String, String>> updateQuestion(QnaQuestionModel question);
  Future<Either<String, String>> changeQuestionActive(String id, bool isActive);

  // qnaAnswers
  Future<Either<String, String>> createAnswer(QnaAnswerModel answer);
  Future<Either<String, String>> incrementAnswerVotes(String id);
  Future<Either<String, String>> decrementAnswerVotes(String id);
  Future<Either<String, List<QnaAnswerModel>>> fetchQnaAnswers(
      String questionId);
  Future<Either<String, String>> deleteAnswer(String id);
  Future<Either<String, String>> updateAnswer(QnaAnswerModel answer);
}

class QnaRepositoryImpl implements QnaRepository {
  final QnaDatasources datasources;
  final ConnectionStatus connectionStatus;

  QnaRepositoryImpl(this.datasources, this.connectionStatus);

  @override
  Future<Either<String, String>> changeQuestionActive(
      String id, bool isActive) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.changeQuestionActive(id, isActive);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> createQuestion(
      QnaQuestionModel question) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.createQuestion(question);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> deleteQuestion(String id) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.deleteQuestion(id);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, List<QnaQuestionModel>>> fetchQnaQuestions() async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.fetchQnaQuestions();
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> incrementAnswersCount(String id) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.incrementAnswersCount(id);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> updateQuestion(
      QnaQuestionModel question) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.updateQuestion(question);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> createAnswer(QnaAnswerModel answer) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.createAnswer(answer);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> decrementAnswerVotes(String id) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.decrementAnswerVotes(id);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> deleteAnswer(String id) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.deleteAnswer(id);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, List<QnaAnswerModel>>> fetchQnaAnswers(
      String questionId) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.fetchQnaAnswers(questionId);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> incrementAnswerVotes(String id) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.incrementAnswerVotes(id);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> updateAnswer(QnaAnswerModel answer) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.updateAnswer(answer);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }
  
  @override
  Future<Either<String, QnaQuestionModel>> fetchQnaQuestion(String questionId) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.fetchQnaQuestion(questionId);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }
}
