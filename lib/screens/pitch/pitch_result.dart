import 'package:conopot/config/analytics_config.dart';
import 'package:conopot/config/constants.dart';
import 'package:conopot/models/music_search_item_lists.dart';
import 'package:conopot/models/pitch_item.dart';
import 'package:conopot/screens/chart/components/pitch_search_list.dart';
import 'package:conopot/config/size_config.dart';
import 'package:conopot/screens/user/user_note_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class PitchResult extends StatefulWidget {
  PitchResult({Key? key, required this.fitchLevel}) : super(key: key);

  final int fitchLevel;

  @override
  State<PitchResult> createState() => _PitchResultState(fitchLevel);
}

class _PitchResultState extends State<PitchResult> {
  final int pitchLevel;

  _PitchResultState(this.pitchLevel);

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
          .changeUserPitch(pitch: pitchLevel);
    });

    Future.delayed(Duration.zero, () {
      Provider.of<MusicSearchItemLists>(context, listen: false)
          .initPitchMusic(pitchNum: pitchLevel);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    SizeConfig().init(context);
    return Consumer<MusicSearchItemLists>(
      builder: (
        context,
        musicList,
        child,
      ) =>
          Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.black),
          title: Text(
            '측정 결과',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.defaultSize,
              ),
              Text(
                '내 최고음',
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: SizeConfig.defaultSize * 2,
              ),

              Container(
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: kTitleColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  pitchNumToString[pitchLevel],
                  style: TextStyle(
                    color: kPrimaryCreamColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(
                height: SizeConfig.defaultSize * 2,
              ),

              SizedBox(
                height: SizeConfig.defaultSize * 3,
              ),

              //내 음역대의 인기곡들
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                  children: [
                    TextSpan(
                      text: '내 ',
                      style: TextStyle(
                        color: kTextColor,
                      ),
                    ),
                    TextSpan(
                      text: '최고음',
                      style: TextStyle(
                        color: kTextColor,
                      ),
                    ),
                    TextSpan(
                      text: ' 주변의 인기곡들',
                      style: TextStyle(
                        color: kTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.defaultSize * 2,
              ),

              Divider(
                height: 1,
              ),
              SizedBox(
                height: SizeConfig.defaultSize,
              ),
              PitchSearchList(musicList: musicList),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // !event : 음역대 측정 결과뷰 - 홈화면으로 이동
            Analytics_config.analytics.logEvent('음역대 측정 결과뷰 - 홈화면으로 이동');
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          label: Text(
            '홈 화면으로 이동',
            style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryCreamColor),
          ),
          icon: Icon(Icons.home),
          backgroundColor: kPrimaryColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
