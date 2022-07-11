import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class Analytics_config {
  static late Amplitude analytics =
      Amplitude.getInstance(instanceName: "conopot");

  void init() {
    // Initialize SDK
    analytics.init('cf1298f461883c1cbf97daeb0393b987');

    // Enable COPPA privacy guard. This is useful when you choose not to report sensitive user information.
    analytics.enableCoppaControl();

    // Turn on automatic session events
    analytics.trackingSessionEvents(true);

    // Log an event
    analytics.logEvent('앱 실행');

    // Identify
    // final Identify identify1 = Identify()
    //   ..set('identify_test',
    //       'identify sent at ${DateTime.now().millisecondsSinceEpoch}')
    //   ..add('identify_count', 1);
    // analytics.identify(identify1);
  }
}
