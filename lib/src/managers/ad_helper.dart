

import 'dart:io';

class AdHelper {
  final bool isTest = ! const bool.fromEnvironment('dart.vm.product');

  String get bannerAdUnitId {
    if (isTest) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-9553130506719526/7133339279";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  String get interstitialAdUnitId {
    if (isTest) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-9553130506719526/2286199091";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  String get rewardedAdUnitId {
    if (isTest) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-9553130506719526/2587589604";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }


  String get rewardedInterstitialAdUnitId {
    if (isTest) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-9553130506719526/6351248791";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  
  String get nativeAdUnitId {
    if(isTest){
      return '/6499/example/native';
    }
    else {
      if (Platform.isAndroid) {
        return "ca-app-pub-9553130506719526/9222057394";
      } else if (Platform.isIOS) {
        return "ca-app-pub-2434981739474696/4764156723";
      } else {
        throw UnsupportedError("Unsupported Platform");
      }
    }
  }
}
