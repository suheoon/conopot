import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:conopot/admob/app_open_ad_manager.dart';
import 'package:conopot/admob/applifecycle_reactor.dart';
import 'package:conopot/firebase/analytics_config.dart';
import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/firebase/firebase_remote_config.dart';
import 'package:conopot/models/music_state.dart';
import 'package:conopot/models/user_state.dart';
import 'package:conopot/screens/home/home_screen.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/models/note.dart';
import 'package:conopot/models/note_state.dart';
import 'package:conopot/global/recommendation_item_list.dart';
import 'package:conopot/models/youtube_player_state.dart';
import 'package:conopot/screens/tutorial/tutorial_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initOneSignal();
    init(context);
    SizeConfig().init(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: const AssetImage('assets/images/splash.png'),
                height: SizeConfig.screenWidth * 0.3,
              ),
            ),
            SizedBox(
              height: SizeConfig.defaultSize * 5,
            ),
            RepaintBoundary(
              child: const CircularProgressIndicator(
                color: kMainColor,
                backgroundColor: Color(0x4DFF9A62),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> init(BuildContext context) async {
    await getInformation(context);
    await initResource(context);
  }

  Future<void> initResource(BuildContext context) async {
    //버전이 존재하는지 체크한다.
    final storage = new FlutterSecureStorage();
    String? userVersionStr = await storage.read(key: 'userVersion');

    //인터넷 연결 확인
    try {
      final result = await InternetAddress.lookup('example.com');

      //("인터넷 연결 성공");
      int sessionCnt =
          Provider.of<UserState>(context, listen: false).sessionCount;

      if (sessionCnt == 0) {
        Analytics_config().firstSessionEvent();
      }

      //firebase remote config 초기화
      await Firebase_Remote_Config().init();
      //이때 remote config - musicUpdateSetting 이 false 라면, 하지 않기
      bool musicUpdateSetting = false;
      musicUpdateSetting =
          Firebase_Remote_Config().remoteConfig.getBool('musicUpdateSetting');
      //만약 버전이 없다면, remote config 상관없이 뭐라도 받아오는 것이 낫다.
      if (userVersionStr == null) {
        musicUpdateSetting = true;
      }

      /// 노래방 곡 관련 초기화
      await Provider.of<MusicState>(context, listen: false)
          .initVersion(musicUpdateSetting, false);

      /// 사용자 노트 초기화 (local storage)
      await Provider.of<NoteState>(context, listen: false).initNotes();
      await RecommendationItemList().initRecommendationList();

      initYoutube(context);

      //앱 오픈 광고
      //리워드, 앱 오픈 플래그가 존재하는지 체크
      String? appOpenFlag = await storage.read(key: 'appOpenFlag');
      //예외적으로, 세션이 10번 이상이면 플래그 등록해두기
      if (sessionCnt >= 10) appOpenFlag = 'true';

      //존재한다면 광고 없이 넘어가기
      if (Provider.of<NoteState>(context, listen: false).isUserAdRemove() ||
          appOpenFlag == null) {
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
      } else {
        appOpenAds(context);
      }
    }
    //인터넷 연결이 안 되어있다면
    on SocketException {
      //버전이 없다면 (첫 설치 이용자라면) -> 인터넷 연결 알림 문구 띄우기
      if (userVersionStr == null) {
        //기존에 있는 txt 파일 사용
        //버전이 존재한다면 -> 버전 체크 없이 초기화 진행
        await Provider.of<MusicState>(context, listen: false)
            .initVersion(false, true);
      } else {
        //버전이 존재한다면 -> 버전 체크 없이 초기화 진행
        await Provider.of<MusicState>(context, listen: false)
            .initVersion(false, false);
      }

      /// 사용자 노트 초기화 (local storage)
      await Provider.of<NoteState>(context, listen: false).initNotes();
      // await SizeConfig().init(context);
      await RecommendationItemList().initRecommendationList();

      /// 튜토리얼 전환
      String? tutorialFlag = await storage.read(key: "tutorial");
      if (tutorialFlag != "1") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => TutorialScreen()));
      } else {
        // 만약 튜토리얼을 완료한 사용자라면 MainScreen 전환 (replace)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      }
    }
  }

  /// 앱 실행 시 얻어야 하는 정보들 수집
  Future<void> getInformation(BuildContext context) async {
    if (Platform.isIOS)
      final status =
          await AppTrackingTransparency.requestTrackingAuthorization();
    await Analytics_config().init();
    // 유저 세션 체크
    await Provider.of<UserState>(context, listen: false).checkSessionCount();
    //Admob 전면광고 캐싱
    await Provider.of<NoteState>(context, listen: false)
        .createInterstitialAd("noteAdd");

    // 첫 설치 사용자라면, 로컬 스토리지를 비운다.
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('first_run') ?? true) {
      FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.delete(key: 'userVersion');
      await storage.delete(key: 'tutorial');
      prefs.setBool('first_run', false);
    }
    // 적응형 광고 크기 초기화
    Provider.of<NoteState>(context, listen: false).initAdSize(context);
  }

  static final String oneSignalAppId = "3dd8ef2b-8d2b-4e05-9499-479c974fed91";

  void initYoutube(BuildContext context) {
    List<Note> notes = Provider.of<NoteState>(context, listen: false).notes;
    Map<String, String> youtubeURL =
        Provider.of<MusicState>(context, listen: false).youtubeURL;
    Provider.of<YoutubePlayerState>(context, listen: false)
        .youtubeInit(notes, youtubeURL);
  }

  void appOpenAds(BuildContext context) {
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd(context);
    WidgetsBinding.instance.addObserver(AppLifecycleReactor(
        appOpenAdManager: appOpenAdManager, context: context));
  }

  // onesignal 설정
  void initOneSignal() async {
    OneSignal.shared.setAppId(oneSignalAppId);
    // 권한 허가
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      event.complete(event.notification);
    });
  }
}
