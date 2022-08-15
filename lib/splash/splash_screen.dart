import 'dart:async';
import 'package:conopot/config/constants.dart';
import 'package:conopot/config/firebase_remote_config.dart';
import 'package:conopot/models/music_search_item_list.dart';
import 'package:conopot/main_screen.dart';
import 'package:conopot/config/size_config.dart';
import 'package:conopot/models/note_data.dart';
import 'package:conopot/models/recommendation_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String connectInfo = "";

  checkConnection() async {
    //인터넷 연결 확인
    bool result = await InternetConnectionChecker().hasConnection;

    //인터넷 연결이 안되어있다면
    if (result == false) {
      //버전이 존재하는지 체크한다.
      final storage = new FlutterSecureStorage();
      String? userVersionStr = await storage.read(key: 'userVersion');
      //버전이 없다면 (첫 설치 이용자라면) -> 인터넷 연결 알림 문구 띄우기
      if (userVersionStr == null) {
        setState(() {
          connectInfo = "첫 실행 시 인터넷 연결이 필요합니다\n 인터넷 연결 상태를 확인해주세요";
        });
      } else {
        //버전이 존재한다면 -> 버전 체크 없이 초기화 진행
        await Provider.of<MusicSearchItemLists>(context, listen: false)
            .initVersion(false);

        /// 사용자 노트 초기화 (local storage)
        await Provider.of<NoteData>(context, listen: false).initNotes();

        await SizeConfig().init(context);

        await RecommendationItemList().initRecommendationList();

        /// 1.5초 후 MainScreen 전환 (replace)
        Timer(const Duration(milliseconds: 1500), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        });
      }
    }
    //인터넷 연결이 되어있다면
    else {
      /// 노래방 곡 관련 초기화
      await Provider.of<MusicSearchItemLists>(context, listen: false)
          .initVersion(true);

      /// 사용자 노트 초기화 (local storage)
      await Provider.of<NoteData>(context, listen: false).initNotes();

      await SizeConfig().init(context);

      await RecommendationItemList().initRecommendationList();

      /// 1초 후 MainScreen 전환 (replace)
      Timer(const Duration(milliseconds: 1000), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      });
    }
  }

  /// 앱 실행 시 얻어야 하는 정보들 수집
  void init() async {
    //Admob 전면광고 캐싱
    await Provider.of<NoteData>(context, listen: false).createInterstitialAd();

    //firebase remote config 초기화
    await Firebase_Remote_Config().init();

    // 첫 설치 사용자라면, 로컬 스토리지를 모두 비운다.
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('first_run') ?? true) {
      FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.delete(key: 'userVersion');
      prefs.setBool('first_run', false);
    }

    checkConnection();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
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
            (connectInfo == "")
                ? const CircularProgressIndicator(
                    color: kMainColor,
                    backgroundColor: Color(0x4DFF9A62),
                  )
                : Column(
                    children: [
                      Text(
                        connectInfo,
                        style: TextStyle(
                            color: kPrimaryWhiteColor,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: SizeConfig.defaultSize,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            connectInfo = "";
                          });
                          checkConnection();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(10.0),
                          primary: kPrimaryWhiteColor,
                          backgroundColor: kMainColor,
                        ),
                        child: const Text("다시 확인하기"),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
