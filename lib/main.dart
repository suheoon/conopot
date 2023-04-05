import 'dart:async';
import 'dart:io';
import 'package:conopot/models/user_state.dart';
import 'package:conopot/player_widget.dart';
import 'package:conopot/firebase/analytics_config.dart';
import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/models/note_state.dart';
import 'package:conopot/models/music_state.dart';
import 'package:conopot/models/youtube_player_state.dart';
import 'package:conopot/screens/splash/splash_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  HttpOverrides.global = NoCheckCertificateHttpOverrides(); 
  await Analytics_config().init();
  await dotenv.load(fileName: "assets/config/.env");
  MobileAds.instance.initialize().then((initializationStatus) {
    initializationStatus.adapterStatuses.forEach((key, value) {
      debugPrint('Adapter status for $key: ${value.description}');
    });
  });
  // 세로 화면 고정
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  KakaoSdk.init(nativeAppKey: 'c5f3c164cf6f6bc40f417898b5284a66');

  /// firebase crashlytics init
  runZonedGuarded<Future<void>>(
    () async {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      runApp(const MyApp());
    },
    (error, stack) =>
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
  );
}

class NoCheckCertificateHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = 
          (X509Certificate cert, String host, int port) => true;
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MusicState()),
        ChangeNotifierProvider<NoteState>(create: (context) => NoteState()),
        ChangeNotifierProvider<UserState>(create: (context) => UserState()),
        ChangeNotifierProvider<YoutubePlayerState>(create: (context) => YoutubePlayerState())
      ],
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus(); // 키보드 닫기
        },
        child: MaterialApp(
          builder: (context, child) {
            child = EasyLoading.init()(context, child);
            child = MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: child,
            );
            child = PlayerWidget(child: child);
            SizeConfig().init(context);
            return child;
          },
          initialRoute: '/',
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          title: 'conopot',
          theme: ThemeData(
              fontFamily: 'pretendard',
              scaffoldBackgroundColor: kBackgroundColor,
              appBarTheme: const AppBarTheme(
                centerTitle: false,
                backgroundColor: kBackgroundColor,
                foregroundColor: kPrimaryWhiteColor,
                elevation: 0,
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              cupertinoOverrideTheme: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                pickerTextStyle: TextStyle(
                    color: kPrimaryWhiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ))),
          home: SplashScreen(),
          navigatorObservers: [
            FirebaseAnalyticsObserver(
                analytics: Analytics_config.firebaseAnalytics),
          ],
        ),
      ),
    );
  }
}
