class AppHiveConfig {
  static const AppHiveConfig _instance = AppHiveConfig._internal();

  factory AppHiveConfig() => _instance;

  const AppHiveConfig._internal();

  static AppHiveConfig get instance => _instance;

  final String linkatiBox = "LinkatiApp";

  final int keyUserID = 0;

  final String keyIsStopAds = 'isStopAds';
  final String keyLastSpinTime = 'lastSpinTime';  
}
