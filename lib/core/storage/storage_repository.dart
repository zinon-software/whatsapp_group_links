abstract class StorageRepository {
  Future<void> close();
  Future<void> setData({required String key, required dynamic value});
  dynamic getData({required String key});
  Future<void> deleteData({required String key});
  logout();
  bool containsKey(String key);

  bool get isStopAds;
}
