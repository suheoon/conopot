import 'dart:async';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:conopot/firebase/firebase_config.dart';
import 'package:conopot/models/note_data.dart';
import 'package:conopot/models/music_search_item_lists.dart';
import 'package:conopot/splash/splash_screen.dart';
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

  // Initialize SDK
  analytics.init('cf1298f461883c1cbf97daeb0393b987');

  // Enable COPPA privacy guard. This is useful when you choose not to report sensitive user information.
  analytics.enableCoppaControl();

  // Set user Id
  analytics.setUserId("test_user");
  // Turn on automatic session events
  analytics.trackingSessionEvents(true);

  // Log an event
  analytics.logEvent('MyApp startup',
      eventProperties: {'friend_num': 10, 'is_heavy_user': true});

  // Identify
  final Identify identify1 = Identify()
    ..set('identify_test',
        'identify sent at ${DateTime.now().millisecondsSinceEpoch}')
    ..add('identify_count', 1);
  analytics.identify(identify1);

  // Set group
  analytics.setGroup('orgId', 15);

  // Group identify
  final Identify identify2 = Identify()..set('identify_count', 1);
  analytics.groupIdentify('orgId', '15', identify2);
}

Future<void> main() async {
  /// firebase crashlytics init
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    /// firebase analytics init
    await Firebase.initializeApp(
        options: DefaultFirebaseConfig.platformOptions);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

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
