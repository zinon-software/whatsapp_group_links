import 'package:dartz/dartz.dart';
import 'package:linkati/core/api/error_handling.dart';
import 'package:linkati/features/challenges/data/models/game_model.dart';
import 'package:linkati/features/challenges/data/models/topic_model.dart';

import '../../../../core/network/connection_status.dart';
import '../datasources/challenges_datasources.dart';
import '../models/question_model.dart';

abstract class ChallengesRepository {
  Future<Either<String, String>> createTopic(TopicModel topic);
  Future<Either<String, String>> updateTopic(TopicModel topic);

  Future<Either<String, List<QuestionModel>>> fetchQuestions(String topic);

  Future<Either<String, String>> createQuestion(QuestionModel question);

  Future<Either<String, String>> updateQuestion(QuestionModel question);

  Future<Either<String, List<TopicModel>>> fetchTopics();

  Future<Either<String, GameModel>> createGame(GameModel game);

  Future<Either<String, GameModel>> joinGameEvent(GameModel game);

  Future<Either<String, GameModel>> endGame(GameModel game);

  Future<Either<String, GameModel>> startGameWithAi(GameModel game);

  Future<Either<String, GameModel>> updateGame(GameModel game);

  Future<Either<String, String>> deleteGame(String id);

  Future<Either<String, String>> deleteQuestion(QuestionModel question);
}

class ChallengesRepositoryImpl implements ChallengesRepository {
  final ChallengesDatasources datasources;
  final ConnectionStatus connectionStatus;

  ChallengesRepositoryImpl(this.datasources, this.connectionStatus);

  @override
  Future<Either<String, String>> createTopic(TopicModel topic) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.createTopic(topic);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> updateTopic(TopicModel topic) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.updateTopic(topic);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, List<QuestionModel>>> fetchQuestions(
      String topic) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.fetchQuestions(topic);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> createQuestion(QuestionModel question) async {
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
  Future<Either<String, String>> updateQuestion(QuestionModel question) async {
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
  Future<Either<String, List<TopicModel>>> fetchTopics() async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.fetchTopics();
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, GameModel>> createGame(GameModel game) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.createGame(game);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, GameModel>> joinGameEvent(GameModel game) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.joinGameEvent(game);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, GameModel>> endGame(GameModel game) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.endGameEvent(game);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, GameModel>> startGameWithAi(GameModel game) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.startGameWithAi(game);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, GameModel>> updateGame(GameModel game) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.updateGame(game);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> deleteGame(String id) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.deleteGame(id);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }
  
  @override
  Future<Either<String, String>> deleteQuestion(QuestionModel question) async{
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.deleteQuestion(question);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }
}
