import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/api/error_handling.dart';
import '../../../../core/network/connection_status.dart';
import '../datasources/challenges_datasources.dart';

abstract class ChallengesRepository {
  // Future<Either<String, String>> updatePermission(
  //   String userId,
  //   String feild,
  //   bool newStatus,
  // );
}

class ChallengesRepositoryImpl implements ChallengesRepository {
  final ChallengesDatasources datasources;
  final ConnectionStatus connectionStatus;

  ChallengesRepositoryImpl(this.datasources, this.connectionStatus);

  // @override
  // Future<Either<String, String>> updatePermission(
  //     String userId, String feild, bool newStatus) async {
  //   if (await connectionStatus.isNotConnected) {
  //     return const Left("تحقق من جودة اتصالك بالانترنت");
  //   }

  //   try {
  //     final response =
  //         await datasources.updatePermission(userId, feild, newStatus);
  //     return Right(response);
  //   } on FirebaseException catch (e) {
  //     return Left(handleFirebaseException(e));
  //   } on Exception catch (e) {
  //     return Left("خطأ: $e");
  //   }
  // }
}
