import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/api/error_handling.dart';
import '../../../../core/network/connection_status.dart';
import '../datasources/users_datasources.dart';
import '../models/user_model.dart';

abstract class UsersRepository {
  Future<Either<String, UserModel>> fetchUser(String id);

  Future<Either<String, String>> createUser(UserModel request);
  Future<Either<String, String>> updateUser(UserModel request);

  Future<Either<String, String>> updatePermission(
    String userId,
    String feild,
    bool newStatus,
  );
}

class UsersRepositoryImpl implements UsersRepository {
  final UsersDatasources datasources;
  final ConnectionStatus connectionStatus;

  UsersRepositoryImpl(this.datasources, this.connectionStatus);

  @override
  Future<Either<String, UserModel>> fetchUser(String id) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.fetchUser(id);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseException(e));
    } on Exception catch (e) {
      return Left("خطأ: $e");
    }
  }

  @override
  Future<Either<String, String>> createUser(UserModel request) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.createUser(request);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseException(e));
    } on Exception catch (e) {
      return Left("خطأ: $e");
    }
  }

  @override
  Future<Either<String, String>> updateUser(UserModel request) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.updateUser(request);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseException(e));
    } on Exception catch (e) {
      return Left("خطأ: $e");
    }
  }

  @override
  Future<Either<String, String>> updatePermission(
      String userId, String feild, bool newStatus) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response =
          await datasources.updatePermission(userId, feild, newStatus);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseException(e));
    } on Exception catch (e) {
      return Left("خطأ: $e");
    }
  }
}
