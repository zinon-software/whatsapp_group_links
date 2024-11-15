import 'package:dartz/dartz.dart';

import '../../../../core/api/error_handling.dart';
import '../../../../core/network/connection_status.dart';
import '../datasources/users_datasources.dart';
import '../models/user_model.dart';

abstract class UsersRepository {
  Future<Either<String, List<UserModel>>> fetchUsers();
  Future<Either<String, UserModel>> fetchUser(String id);

  Future<Either<String, String>> createUser(UserModel request);
  Future<Either<String, String>> updateUser(UserModel request);

  Future<Either<String, String>> updatePermission(
    String userId,
    String feild,
    bool newStatus,
  );

  Future<Either<String, String>> incrementScore(String uid);
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
    } catch (e) {
      return Left(handleException(e));
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
    } catch (e) {
      return Left(handleException(e));
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
    } catch (e) {
      return Left(handleException(e));
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
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> incrementScore(String uid) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.incrementScore(uid);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }
  
  @override
  Future<Either<String, List<UserModel>>> fetchUsers() async{
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.fetchUsers();
      return Right(response);
    } catch (e) { 
      return Left(handleException(e));
    }
  }
}
