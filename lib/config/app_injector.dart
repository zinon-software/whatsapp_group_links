import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import '../core/api/app_collections.dart';
import '../core/network/connection_status.dart';
import '../features/challenges/data/datasources/challenges_datasources.dart';
import '../features/challenges/data/repositories/challenges_repositories.dart';
import '../features/links/data/datasources/links_datasources.dart';
import '../features/links/data/repositories/links_repositories.dart';
import '../features/users/data/datasources/users_datasources.dart';
import '../features/users/data/repositories/users_repositories.dart';

final instance = GetIt.instance;

void setupGetIt() {
  // // Hive
  // await Hive.initFlutter();

  // Hive.registerAdapter(BaseCityModelAdapter());

  // Box box = await Hive.openBox(AppHiveConfig.instance.wasselakCustomerBox);

  // instance.registerLazySingleton<StorageRepository>(() => HiveStorage(box));

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
}

void stupUsers() {
  // data Source
  if (!GetIt.I.isRegistered<UsersDatasources>()) {
    instance.registerLazySingleton<UsersDatasources>(
      () => UsersDatasourcesImpl(
        instance<AppCollections>().users,
      ),
    );
  }
  // Repository
  if (!GetIt.I.isRegistered<UsersRepository>()) {
    instance.registerLazySingleton<UsersRepository>(
      () => UsersRepositoryImpl(
        instance<UsersDatasources>(),
        instance<ConnectionStatus>(),
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
        sessions: instance<AppCollections>().sessions,
        sections: instance<AppCollections>().sections,
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