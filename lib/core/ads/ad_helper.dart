

import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdHelper {
  final bool _testMode = ! const bool.fromEnvironment('dart.vm.product');

  String get bannerAdUnitId {
    if (_testMode) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isAndroid) {
      return dotenv.env['BANNER_AD_UNIT_ID_ANDROID']!;
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  String get interstitialAdUnitId {
    if (_testMode) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isAndroid) {
      return dotenv.env['INTERSTITIAL_AD_UNIT_ID_ANDROID']!;
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  String get rewardedAdUnitId {
    if (_testMode) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isAndroid) {
      return dotenv.env['REWARDED_AD_UNIT_ID_ANDROID']!;
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }


  String get rewardedInterstitialAdUnitId {
    if (_testMode) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isAndroid) {
      return dotenv.env['REWARDED_INTERSTITIAL_AD_UNIT_ID_ANDROID']!;
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  
  String get nativeAdUnitId {
    if(_testMode){
      return '/6499/example/native';
    }
    else {
      if (Platform.isAndroid) {
        return dotenv.env['NATIVE_AD_UNIT_ID_ANDROID']!;
      } else if (Platform.isIOS) {
        return "ca-app-pub-2434981739474696/4764156723";
      } else {
        throw UnsupportedError("Unsupported Platform");
      }
    }
  }
}
