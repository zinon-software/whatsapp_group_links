import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/api/app_collections.dart';
import '../core/network/connection_status.dart';
import '../core/storage/hive_storage.dart';
import '../core/storage/storage_repository.dart';
import '../features/challenges/data/datasources/challenges_datasources.dart';
import '../features/challenges/data/repositories/challenges_repositories.dart';
import '../features/links/data/datasources/links_datasources.dart';
import '../features/links/data/repositories/links_repositories.dart';
import '../features/main/data/datasources/main_datasources.dart';
import '../features/main/data/repositories/main_repositories.dart';
import '../features/qna/data/datasources/qna_datasources.dart';
import '../features/qna/data/repositories/qna_repositories.dart';
import '../features/users/data/datasources/users_local_datasources.dart';
import '../features/users/data/datasources/users_remote_datasources.dart';
import '../features/users/data/models/user_model_adapter.dart';
import '../features/users/data/repositories/users_repositories.dart';
import 'app_hive_config.dart';

final instance = GetIt.instance;

Future<void> setupGetIt() async {
  await sutpHive();

  // InternetConnection
  final Connectivity internetConnection = Connectivity();

  //! Core
  instance.registerLazySingleton<ConnectionStatus>(
    () => InternetConnectionStatus(checker: internetConnection),
  );

  instance.registerLazySingleton<AppCollections>(() => AppCollections.instance);

  stupUsers();
  stupLinks();
  stupChallenges();
  stupMain();
  stupQna();
}

Future<void> sutpHive() async {
  // // Hive
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());

  Box box = await Hive.openBox(AppHiveConfig.instance.linkatiBox);

  instance.registerLazySingleton<StorageRepository>(() => HiveStorage(box));
}

void stupUsers() {
  // remote data Source
  if (!GetIt.I.isRegistered<UsersRemoteDatasources>()) {
    instance.registerLazySingleton<UsersRemoteDatasources>(
      () => UsersRemoteDatasourcesImpl(
        instance<AppCollections>().users,
      ),
    );
  }
  // local data Source
  if (!GetIt.I.isRegistered<UsersLocalDatasources>()) {
    instance.registerLazySingleton<UsersLocalDatasources>(
      () => UsersLocalDatasourcesImpl(
        storageRepository: instance<StorageRepository>(),
      ),
    );
  }

  // Repository
  if (!GetIt.I.isRegistered<UsersRepository>()) {
    instance.registerLazySingleton<UsersRepository>(
      () => UsersRepositoryImpl(
        remoteDatasources: instance<UsersRemoteDatasources>(),
        localDatasources: instance<UsersLocalDatasources>(),
        connectionStatus: instance<ConnectionStatus>(),
      ),
    );
  }
}

void stupChallenges() {
  // data Source
  if (!GetIt.I.isRegistered<ChallengesDatasources>()) {
    instance.registerLazySingleton<ChallengesDatasources>(
      () => ChallengesDatasourcesImpl(
        questions: instance<AppCollections>().questions,
        games: instance<AppCollections>().games,
        topics: instance<AppCollections>().topics,
      ),
    );
  }
  // Repository
  if (!GetIt.I.isRegistered<ChallengesRepository>()) {
    instance.registerLazySingleton<ChallengesRepository>(
      () => ChallengesRepositoryImpl(
        instance<ChallengesDatasources>(),
        instance<ConnectionStatus>(),
      ),
    );
  }
}

void stupLinks() {
  // data Source
  if (!GetIt.I.isRegistered<LinksDatasources>()) {
    instance.registerLazySingleton<LinksDatasources>(
      () => LinksDatasourcesImpl(
        links: instance<AppCollections>().links,
        bannedWords: instance<AppCollections>().bannedWords,
      ),
    );
  }
  // Repository
  if (!GetIt.I.isRegistered<LinksRepository>()) {
    instance.registerLazySingleton<LinksRepository>(
      () => LinksRepositoryImpl(
        instance<LinksDatasources>(),
        instance<ConnectionStatus>(),
      ),
    );
  }
}

void stupMain() {
  // data Source
  if (!GetIt.I.isRegistered<MainDatasources>()) {
    instance.registerLazySingleton<MainDatasources>(
      () => MainDatasourcesImpl(
        slideshows: instance<AppCollections>().slideshows,
      ),
    );
  }
  // Repository
  if (!GetIt.I.isRegistered<MainRepository>()) {
    instance.registerLazySingleton<MainRepository>(
      () => MainRepositoryImpl(
        instance<MainDatasources>(),
        instance<ConnectionStatus>(),
      ),
    );
  }
}

void stupQna() {
  // data Source
  if (!GetIt.I.isRegistered<QnaDatasources>()) {
    instance.registerLazySingleton<QnaDatasources>(
      () => QnaDatasourcesImpl(
        questions: instance<AppCollections>().qnaQuestions,
        answers: instance<AppCollections>().qnaAnswers,
      ),
    );
  }

  // Repository
  if (!GetIt.I.isRegistered<QnaRepository>()) {
    instance.registerLazySingleton<QnaRepository>(
      () => QnaRepositoryImpl(
        instance<QnaDatasources>(),
        instance<ConnectionStatus>(),
      ),
    );
  }
}
