import 'package:dartz/dartz.dart';
import 'package:linkati/core/api/error_handling.dart';
import 'package:linkati/features/challenges/data/models/section_model.dart';

import '../../../../core/network/connection_status.dart';
import '../datasources/challenges_datasources.dart';

abstract class ChallengesRepository {
  Future<Either<String, String>> createSection(SectionModel section);
  Future<Either<String, String>> updateSection(SectionModel section);
  
}

class ChallengesRepositoryImpl implements ChallengesRepository {
  final ChallengesDatasources datasources;
  final ConnectionStatus connectionStatus;

  ChallengesRepositoryImpl(this.datasources, this.connectionStatus);

  @override
  Future<Either<String, String>> createSection(SectionModel section) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.createSection(section);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }
  
  @override
  Future<Either<String, String>> updateSection(SectionModel section)  async{
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.updateSection(section);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }
}
