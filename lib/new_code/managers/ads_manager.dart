import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class AdsManager {
  static final AdsManager _instance = AdsManager._internal();
  factory AdsManager() => _instance;

  AdsManager._internal();

  final AdRequest request = const AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  static const int maxFailedLoadAttempts = 3;

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  // تعريف المتغير لتتبع الوقت الذي تم فيه عرض الإعلان السابق
  DateTime? _lastInterstitialAdTime;

  RewardedAd? _rewardedAd;
  // تعريف المتغير لتتبع الوقت الذي تم فيه عرض الإعلان المكافأة السابق
  DateTime? _lastRewardedAdTime;
  int _numRewardedLoadAttempts = 0;

  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _numRewardedInterstitialLoadAttempts = 0;

  late BannerAd _bannerAd;

  AppOpenAd? openAd;

  late NativeAd _nativeAd;
  bool nativeAdIsLoaded = false;

// add banner ads

  void _createBannerAd({AdSize? adSize}) {
    _bannerAd = BannerAd(
      adUnitId: AdHelper().bannerAdUnitId,
      size: adSize ?? AdSize.banner,
      request: request,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          log('Banner Ad loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          log('Banner Ad failed to load: $error');
        },
      ),
    );
    _bannerAd.load();
  }

  void loadBannerAd({AdSize? adSize}) {
    _createBannerAd(adSize: adSize);
  }

  Widget getBannerAdWidget({AdSize? adSize}) {
    return _BannerAdWidget(adSize: adSize,);
    // log(_bannerAd.size.height.toDouble().toString());
    // return StatefulBuilder(
    //   builder: (context, setState) {
    //     return SizedBox(
    //       height: _bannerAd.size.height.toDouble(),
    //       width: _bannerAd.size.width.toDouble(),
    //       child: AdWidget(ad: _bannerAd),
    //     );
    //   },
    // );
  }

  void disposeBannerAds() {
    _bannerAd.dispose();
  }
  // end banner ads

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper().interstitialAdUnitId,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          log('$ad loaded');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper().rewardedAdUnitId,
      request: request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          log('$ad loaded.');
          _rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('RewardedAd failed to load: $error');
          _rewardedAd = null;
          _numRewardedLoadAttempts += 1;
          if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
            _createRewardedAd();
          }
        },
      ),
    );
  }

  void _createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
      adUnitId: AdHelper().rewardedAdUnitId,
      request: request,
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {
          log('$ad loaded.');
          _rewardedInterstitialAd = ad;
          _numRewardedInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('RewardedInterstitialAd failed to load: $error');
          _rewardedInterstitialAd = null;
          _numRewardedInterstitialLoadAttempts += 1;
          if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
            _createRewardedInterstitialAd();
          }
        },
      ),
    );
  }

  void loadInterstitialAd() {
    _createInterstitialAd();
  }

  void loadRewardedAd() {
    _createRewardedAd();
  }

  void loadRewardedInterstitialAd() {
    _createRewardedInterstitialAd();
  }

  // عرض الاعلان البيني
  void showInterstitialAd() {
    if (_interstitialAd == null) {
      log('Warning: attempt to show interstitial before loaded.');
      return;
    }

    // التحقق مما إذا كان الإعلان السابق قد تم عرضه قبل أكثر من 30 ثانية أو لا
    if (_lastInterstitialAdTime != null &&
        DateTime.now().difference(_lastInterstitialAdTime!) <
            const Duration(seconds: 30)) {
      log('تحذير: لم يتم عرض الإعلان الجديد بعد 30 ثانية.');
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        log('الإعلان تم عرضه بالكامل.');
        // تحديث الوقت الذي تم فيه عرض الإعلان البيني
        _lastInterstitialAdTime = DateTime.now();
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        log('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  // عرض اعلان المكافئة
  void showRewardedAd() {
    if (_rewardedAd == null) {
      log('Warning: attempt to show rewarded before loaded.');
      return;
    }

    // التحقق مما إذا كان الإعلان المكافأة السابق قد تم عرضه قبل أكثر من 30 ثانية أم لا
    if (_lastRewardedAdTime != null &&
        DateTime.now().difference(_lastRewardedAdTime!) <
            const Duration(seconds: 30)) {
      log('تحذير: لم يتم عرض الإعلان المكافأة الجديد بعد 30 ثانية.');
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        log('ad onAdShowedFullScreenContent.');

        log('تم عرض الإعلان المكافأة بالكامل.');
        // تحديث الوقت الذي تم فيه عرض الإعلان المكافأة
        _lastRewardedAdTime = DateTime.now();
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        log('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
      onUserEarnedReward: (Ad ad, RewardItem reward) {
        log('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      },
    );
    _rewardedAd = null;
  }

  void showRewardedInterstitialAd() {
    if (_rewardedInterstitialAd == null) {
      log('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
          log('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        log('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedInterstitialAd();
      },
      onAdFailedToShowFullScreenContent:
          (RewardedInterstitialAd ad, AdError error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedInterstitialAd();
      },
    );

    _rewardedInterstitialAd!.setImmersiveMode(true);
    _rewardedInterstitialAd!.show(
      onUserEarnedReward: (Ad ad, RewardItem reward) {
        log('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      },
    );
    _rewardedInterstitialAd = null;
  }

  Future<void> loadAppOpenAd() async {
    await AppOpenAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/3419835294',
      request: request,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          log('ad is loaded');
          openAd = ad;
          // openAd!.show();
        },
        onAdFailedToLoad: (error) {
          log('ad failed to load $error');
        },
      ),
      // orientation: AppOpenAd.orientationPortrait,
    );
  }

  void showAppOpenAd() {
    if (openAd == null) {
      log('trying tto show before loading');
      loadAppOpenAd();
      return;
    }

    openAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        log('onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        log('failed to load $error');
        openAd = null;
        loadAppOpenAd();
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        log('dismissed');
        openAd = null;
        loadAppOpenAd();
      },
    );

    openAd!.show();
  }

  // اعلان مدمج مع المحتوى
  // تكوين الإعلان المدمج
  void _loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: AdHelper().nativeAdUnitId,
      request: request,
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          log('$NativeAd loaded.NativeAd');
          // setState(() {
          nativeAdIsLoaded = true;
          // });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          log('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => log('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => log('$NativeAd onAdClosed.'),
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.white12,
        callToActionTextStyle: NativeTemplateTextStyle(
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black38,
          backgroundColor: Colors.white70,
        ),
      ),
    );

    _nativeAd.load();
  }

  // عرض الإعلان المدمج
  Widget getNativeAdWidget() {
    return const NativeAdWidget();
  }

  // استدعاء هذه الدالة لتحميل الإعلان المدمج
  void loadNativeAd() {
    _loadNativeAd();
  }

  void disposeNativeAd() {
    _nativeAd.dispose();
  }




}



class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({super.key});

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {

  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  @override
  Widget build(BuildContext context) {
    if ( _nativeAd != null && _nativeAdIsLoaded) {
      return Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 320, // minimum recommended width
              minHeight: 320, // minimum recommended height
              maxWidth: 400,
              maxHeight: 400,
            ),
            child: AdWidget(ad: _nativeAd!),
            // child: AdWidget(ad: _nativeAd!),
          ));
    }
    else {
      return const SizedBox();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Create the ad objects and load ads.
    _nativeAd = NativeAd(
      adUnitId:  AdHelper().nativeAdUnitId,
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(

        // adChoicesPlacement: AdChoi
      ),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('_NativeAdWidget $NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd _NativeAdWidget failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('_NativeAdWidget $NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('_NativeAdWidget $NativeAd onAdClosed.'),
      ),
      // nativeTemplateStyle: NativeTemplateStyle(
      //   // Required: Choose a template.
      //   templateType: TemplateType.medium,
      //   // Optional: Customize the ad's style.
      //   mainBackgroundColor: Colors.purple,
      //   cornerRadius: 10.0,
      //   callToActionTextStyle: NativeTemplateTextStyle(
      //       textColor: Colors.cyan,
      //       backgroundColor: Colors.red,
      //       style: NativeTemplateFontStyle.monospace,
      //       size: 16.0),
      //   primaryTextStyle: NativeTemplateTextStyle(
      //       textColor: Colors.red,
      //       backgroundColor: Colors.cyan,
      //       style: NativeTemplateFontStyle.italic,
      //       size: 16.0),
      //   secondaryTextStyle: NativeTemplateTextStyle(
      //       textColor: Colors.green,
      //       backgroundColor: Colors.black,
      //       style: NativeTemplateFontStyle.bold,
      //       size: 16.0),
      //   tertiaryTextStyle: NativeTemplateTextStyle(
      //       textColor: Colors.brown,
      //       backgroundColor: Colors.amber,
      //       style: NativeTemplateFontStyle.normal,
      //       size: 16.0),
      // ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.white12,
        callToActionTextStyle: NativeTemplateTextStyle(
          size: 16.0,
          // backgroundColor: ColorManager.primaryColor,
        ),
        cornerRadius: 2,
        primaryTextStyle: NativeTemplateTextStyle(
          // textColor: Colors.black38,
          // textColor: ColorManager.name,
          // fontSize: 10.sp,
          backgroundColor: Colors.white70,
        ),
      ),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
  }
}


class _BannerAdWidget extends StatefulWidget {

  final AdSize? adSize;
  const _BannerAdWidget({this.adSize});
  @override
  State<_BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<_BannerAdWidget> {

  late BannerAd _bannerAd;



  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bannerAd =BannerAd(
      adUnitId: AdHelper().bannerAdUnitId,
      size: widget.adSize ?? AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          log('Banner Ad loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          log('Banner Ad failed to load: $error');
        },
      ),
    )..load();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _bannerAd.size.height.toDouble(),
      width: _bannerAd.size.width.toDouble(),
      child: AdWidget(ad: _bannerAd),
    );
  }
}




class AdHelper {
  // final bool _testMode = true;
  final bool isRelease = const bool.fromEnvironment('dart.vm.product');

  String get bannerAdUnitId {
    if (!isRelease) {
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
    if (!isRelease) {
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
    if (!isRelease) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-9553130506719526/2587589604";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  
  String get nativeAdUnitId {
    if(!isRelease){
      return '/6499/example/native';
    }
    else {
      if (Platform.isAndroid) {
        return "ca-app-pub-2434981739474696/5341907076";
      } else if (Platform.isIOS) {
        return "ca-app-pub-2434981739474696/4764156723";
      } else {
        throw UnsupportedError("Unsupported Platform");
      }
    }
  }
}
