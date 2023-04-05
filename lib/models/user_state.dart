import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserState extends ChangeNotifier {
  final storage = new FlutterSecureStorage();
  int sessionCount = 0;
  bool recommendRequest = false;

  // 유저 세션 체크
  checkSessionCount() async {
    String? _sessionCount = await storage.read(key: 'sessionCount');
    if (_sessionCount == null) {
      await storage.write(key: 'sessionCount', value: '0');
      sessionCount = 0;
    } else {
      sessionCount = int.parse(_sessionCount);
      sessionCount += 1;
      await storage.write(key: 'sessionCount', value: sessionCount.toString());
    }
    // 추천 요청 api 요청 여부
    String? recommend = await storage.read(key: 'recommendRequest');
    if (recommend != null) {
      recommendRequest = true;
    }
    notifyListeners();
  }
}
