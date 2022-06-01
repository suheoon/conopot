import 'package:conopot/constants.dart';
import 'package:conopot/models/MusicSearchItemLists.dart';
import 'package:conopot/models/NavItem.dart';
import 'package:conopot/screens/chart/chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class FitchResult extends StatefulWidget {
  FitchResult({Key? key, required this.pitchLevel}) : super(key: key);

  final int pitchLevel;

  @override
  State<FitchResult> createState() => _FitchResultState(pitchLevel);
}

class _FitchResultState extends State<FitchResult> {
  final int pitchLevel;

  _FitchResultState(this.pitchLevel);

  @override
  void initState() {
    setUserFitch();
    super.initState();
  }

  Future<void> setUserFitch() async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'userPitch', value: pitchLevel.toString());

    Future.delayed(Duration.zero, () {
      Provider.of<MusicSearchItemLists>(context, listen: false)
          .changeUserFitch(pitch: pitchLevel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: Text(
          '측정 결과',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Text(
            '내 최고음 구간',
            style: TextStyle(
              color: kTextLightColor,
              fontSize: 15,
            ),
          ),
          Text(pitchLevel.toString()),
          TextButton(
            onPressed: () {
              Future.delayed(Duration.zero, () {
                Provider.of<NavItems>(context, listen: false)
                    .changeNavIndex(index: 1);
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChartScreen(),
                ),
              );
            },
            child: Text('나에게 맞는 노래 찾으러 가기'),
          ),
        ],
      ),
    );
  }
}
