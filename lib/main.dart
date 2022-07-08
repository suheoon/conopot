import 'dart:async';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:conopot/firebase/firebase_config.dart';
import 'package:conopot/models/note_data.dart';
import 'package:conopot/models/music_search_item_lists.dart';
import 'package:conopot/splash/splash_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> firebaseInit() async {
  /// firebase analytics init
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
}

/// Amplitude init
Future<void> amplitudeInit() async {
  // Create the instance
  final Amplitude analytics = Amplitude.getInstance(instanceName: "project");
}

Future<void> main() async {
  /// firebase crashlytics init
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    /// firebase analytics init
    await Firebase.initializeApp(
        options: DefaultFirebaseConfig.platformOptions);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    await FirebaseAnalytics.instance.logBeginCheckout(
        value: 10.0,
        currency: 'USD',
        items: [
          AnalyticsEventItem(
              itemName: 'Socks', itemId: 'xjw73ndnw', price: 10.0),
        ],
        coupon: '10PERCENTOFF');

    amplitudeInit();

    runApp(const MyApp());
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MusicSearchItemLists()),
        ChangeNotifierProvider<NoteData>(create: (context) => NoteData()),
      ],
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus(); // 키보드 닫기
        },
        child: MaterialApp(
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          title: 'conopot',
          theme: ThemeData(
            fontFamily: 'pretendard',
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
