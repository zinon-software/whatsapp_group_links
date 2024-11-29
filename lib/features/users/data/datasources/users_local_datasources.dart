import 'package:linkati/core/storage/storage_repository.dart';

import '../models/user_model.dart';

abstract class UsersLocalDatasources {
  UserModel? getUser(String id);
  UserModel? getMyUser();

  void saveUser(UserModel user);
  void saveMyUser(UserModel user);
}

class UsersLocalDatasourcesImpl implements UsersLocalDatasources {
  final StorageRepository storageRepository;

  UsersLocalDatasourcesImpl({required this.storageRepository});

  @override
  void saveUser(UserModel user) {
    storageRepository.setData(key: user.id, value: user);
  }

  @override
  UserModel? getUser(String id) {
    if (storageRepository.containsKey(id)) {
      return storageRepository.getData(key: id) as UserModel;
    }
    return null;
  }

  
  @override
  void saveMyUser(UserModel user) {
    storageRepository.setData(key: "myUser", value: user);
  }

  @override
  UserModel? getMyUser() {
    if (storageRepository.containsKey("myUser")) {
      return storageRepository.getData(key: "myUser") as UserModel;
    }
    return null;
  }
}
