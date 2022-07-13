import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:conopot/firebase/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

class Analytics_config {
  static late Amplitude analytics =
      Amplitude.getInstance(instanceName: "conopot");

  static late FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    firebaseAnalytics.logAppOpen();
    // Initialize SDK
    analytics.init('cf1298f461883c1cbf97daeb0393b987');

    // Enable COPPA privacy guard. This is useful when you choose not to report sensitive user information.
    analytics.enableCoppaControl();

    // Turn on automatic session events
    analytics.trackingSessionEvents(true);

    // Log an event
    analytics.logEvent('앱 실행');
  }
}
