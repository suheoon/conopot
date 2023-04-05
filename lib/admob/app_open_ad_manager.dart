import 'package:conopot/firebase/analytics_config.dart';
import 'package:conopot/screens/home/home_screen.dart';
import 'package:conopot/models/note_state.dart';
import 'package:conopot/screens/tutorial/tutorial_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

import 'package:provider/provider.dart';

bool canShowOpenAd = true;

final storage = new FlutterSecureStorage();

class AppOpenAdManager {
  Map<String, String> APP_OPEN_UNIT_ID = {
    'android': 'ca-app-pub-7139143792782560/8356395062',
    'ios': 'ca-app-pub-7139143792782560/6434893013',
  };

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  /// Load an [AppOpenAd].
  void loadAd(BuildContext context) {
    AppOpenAd.load(
      adUnitId: APP_OPEN_UNIT_ID[Platform.isIOS ? 'ios' : 'android']!,
      orientation: AppOpenAd.orientationPortrait,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;

          showAdIfAvailable(context);
        },
        onAdFailedToLoad: (error) {
          Analytics_config().adAppOpenFail();
          Provider.of<NoteState>(context, listen: false)
              .appOpenAdUnloaded(context);
        },
      ),
    );
  }

  void showAdIfAvailable(BuildContext context) {
    if (!canShowOpenAd) return;
    if (!isAdAvailable) {
      loadAd(context);
      Analytics_config().adAppOpenSuccess();
      return;
    }
    if (_isShowingAd) {
      canShowOpenAd = false;
      return;
    }

    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd(context);
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) async {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd(context);

        /// 튜토리얼 전환
        String? tutorialFlag = await storage.read(key: "tutorial");
        if (tutorialFlag != "1") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => TutorialScreen()));
        } else {
          // 만약 튜토리얼을 완료한 사용자라면 MainScreen 전환 (replace)
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        }
      },
    );
    canShowOpenAd = false;
    _appOpenAd!.show();
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }
}
