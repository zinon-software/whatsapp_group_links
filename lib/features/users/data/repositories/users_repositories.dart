import 'package:dartz/dartz.dart';

import '../../../../core/api/error_handling.dart';
import '../../../../core/network/connection_status.dart';
import '../datasources/users_local_datasources.dart';
import '../datasources/users_remote_datasources.dart';
import '../models/user_model.dart';

abstract class UsersRepository {
  Future<Either<String, List<UserModel>>> fetchUsers();
  Future<Either<String, UserModel>> fetchUser(String id);
  UserModel? getUser(String id);
  UserModel? getMyUser();

  Future<Either<String, String>> createUser(UserModel request);
  Future<Either<String, String>> updateUser(UserModel request);

  Future<Either<String, String>> updatePermission(
    String userId,
    String feild,
    bool newStatus,
  );

  Future<Either<String, UserModel>> incrementScore(String uid, int score);
}

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDatasources remoteDatasources;
  final UsersLocalDatasources localDatasources;
  final ConnectionStatus connectionStatus;

  UsersRepositoryImpl({
    required this.remoteDatasources,
    required this.connectionStatus,
    required this.localDatasources,
  });

  @override
  Future<Either<String, UserModel>> fetchUser(String id) async {
    if (await connectionStatus.isNotConnected) {
      return localDatasources.getUser(id) != null
          ? Right(localDatasources.getUser(id)!)
          : const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await remoteDatasources.fetchUser(id);

      localDatasources.saveUser(response);

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
      final response = await remoteDatasources.createUser(request);
      localDatasources.saveMyUser(request);
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
      final response = await remoteDatasources.updateUser(request);
      localDatasources.saveMyUser(request);
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
      final response = await remoteDatasources.updatePermission(
        userId,
        feild,
        newStatus,
      );
      
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, UserModel>> incrementScore(
      String uid, int score) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await remoteDatasources.incrementScore(uid, score);
      localDatasources.saveUser(response);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, List<UserModel>>> fetchUsers() async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await remoteDatasources.fetchUsers();
      for (var user in response) {
        localDatasources.saveUser(user);
      }
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  UserModel? getUser(String id) {
    return localDatasources.getUser(id);
  }

  @override
  UserModel? getMyUser() {
    return localDatasources.getMyUser();
  }
}
