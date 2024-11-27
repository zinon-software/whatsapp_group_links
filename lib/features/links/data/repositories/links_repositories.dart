import 'package:dartz/dartz.dart';

import '../../../../core/api/error_handling.dart';
import '../../../../core/network/connection_status.dart';
import '../datasources/links_datasources.dart';
import '../models/link_model.dart';

abstract class LinksRepository {
  // links
  Future<Either<String, String>> createLink(LinkModel link);
  Future<Either<String, String>> incrementViews(String id);
  Future<Either<String, List<LinkModel>>> fetchLinks();
  Future<Either<String, String>> deleteLink(String id);
  Future<Either<String, String>> updateLink(LinkModel link);
  Future<Either<String, String>> changeLinkActive(String id, bool isActive);

  // banned words
  Future<Either<String, String>> createBannedWord(String word);
  Future<Either<String, List<String>>> fetchBannedWords();
  Future<Either<String, String>> deleteBannedWord(String word);
  Future<Either<String, bool>> checkBannedWord(String word);
}

class LinksRepositoryImpl implements LinksRepository {
  final LinksDatasources datasources;
  final ConnectionStatus connectionStatus;

  LinksRepositoryImpl(this.datasources, this.connectionStatus);

  @override
  Future<Either<String, String>> changeLinkActive(
      String id, bool isActive) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.changeLinkActive(id, isActive);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> createLink(LinkModel link) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.createLink(link);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> deleteLink(String id) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.deleteLink(id);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, List<LinkModel>>> fetchLinks() async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.fetchLinks();
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> incrementViews(String id) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.incrementViews(id);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> updateLink(LinkModel link) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.updateLink(link);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> createBannedWord(String word) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.createBannedWord(word);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> deleteBannedWord(String word) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.deleteBannedWord(word);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, List<String>>> fetchBannedWords() async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.fetchBannedWords();
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, bool>> checkBannedWord(String word) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.checkBannedWord(word);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }
}
