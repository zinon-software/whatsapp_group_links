import 'package:hive/hive.dart';
import 'package:linkati/config/app_hive_config.dart';

import 'storage_repository.dart';

class HiveStorage implements StorageRepository {
  final Box _box;

  HiveStorage(this._box);

  @override
  Future<void> close() async {
    await _box.close();
  }

  @override
  Future<void> deleteData({required String key}) async {
    await _box.delete(key);
  }

  @override
  dynamic getData({required String key}) {
    if (_box.get(key) == null) {
      return null;
    }
    return _box.get(key);
  }

  @override
  logout() async {
    // setData(
    //   key: AppHiveConfig.instance.kRegisteredNotification,
    //   value: false,
    // );

    // instance<CurrentUserModel>().insertData(
    //   accessToken: null,
    //   refreshToken: null,
    //   account: null,
    //   hasPin: false,
    // );

    // AppNavigation.navigatorKey.currentState
    //     ?.pushReplacementNamed(AppRoutes.phoneLoginRoute);
    // initAuthFeatures();
    // _box.delete(AppHiveConfig.instance.keyTokenStorage);
  }

  @override
  Future<void> setData({required String key, required value}) async {
    await _box.put(key, value);
  }

  @override
  bool containsKey(String key) {
    return _box.containsKey(key);
  }

  @override
  bool get isStopAds =>
      getData(key: AppHiveConfig.instance.keyIsStopAds) ?? false;
}
