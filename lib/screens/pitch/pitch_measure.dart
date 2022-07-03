import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:conopot/components/custom_page_route.dart';
import 'package:conopot/config/constants.dart';
import 'package:conopot/models/music_search_item_lists.dart';
import 'package:conopot/models/pitch_item.dart';
import 'package:conopot/screens/pitch/components/indicator.dart';
import 'package:conopot/screens/pitch/components/pitch_banner.dart';
import 'package:conopot/config/size_config.dart';
import 'package:conopot/screens/pitch/pitch_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:provider/provider.dart';

class PitchMeasure extends StatefulWidget {
  PitchMeasure({Key? key}) : super(key: key);

  @override
  State<PitchMeasure> createState() => _PitchMeasureState();
}

class _PitchMeasureState extends State<PitchMeasure> {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);

  var note = ""; //음정 알파벳
  double frequency = 0; //진동수
  String ret = ""; //사용자가 측정한 음정
  int flag = 0; //음 측정 중인지 확인
  String nowPitchName = "";

  Future<void> _startCapture() async {
    //마이크 사용 권한 확인 (android)
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.microphone].request();
      //만약 있다면
      if (statuses[Permission.microphone]!.isGranted) {
        await _audioRecorder.start(listener, onError,
            sampleRate: 44100, bufferSize: 3000);

        setState(() {
          note = "";
        });
      } else {
        openAppSettings();
      }
    } else {
      await _audioRecorder.start(listener, onError,
          sampleRate: 44100, bufferSize: 3000);

      setState(() {
        note = "";
      });
    }
  }

  Future<void> _stopCapture() async {
    await _audioRecorder.stop();

    setState(() {
      note = "";
      frequency = 0;
    });
  }

  void onError(Object e) {
    print(e);
  }

  void listener(dynamic obj) {
    //Gets the audio sample
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();

    //Uses pitch_detector_dart library to detect a pitch from the audio sample
    final result = pitchDetectorDart.getPitch(audioSample);

    //If there is a pitch - evaluate it
    if (result.pitched) {
      //Uses the pitchupDart library to check a given pitch for a Guitar
      final handledPitchResult = pitchupDart.handlePitch(result.pitch);

      //Updates the state with the result
      setState(() {
        note = handledPitchResult.note;
        frequency = handledPitchResult.expectedFrequency;
        frequencyToPitch();
        if (ret == nowPitchName) flag = 2;
      });
    }
  }

  void play(String fitch) async {
    _stopCapture();
    final player = AudioCache(prefix: 'assets/fitches/');
    await player.play('$fitch.mp3');

    setState(() {
      flag = 1;
    });

    //누르고 1초 후 음 측정 시작
    Timer(Duration(milliseconds: 2000), () {
      _startCapture();
    });
  }

  String frequencyToPitch() {
    if (130 <= frequency && frequency <= 135)
      ret = "1옥타브 도";
    else if (145 <= frequency && frequency <= 150)
      ret = "1옥타브 레";
    else if (160 <= frequency && frequency <= 165)
      ret = "1옥타브 미";
    else if (173 <= frequency && frequency <= 178)
      ret = "1옥타브 파";
    else if (195 <= frequency && frequency <= 200)
      ret = "1옥타브 솔";
    else if (218 <= frequency && frequency <= 223)
      ret = "1옥타브 라";
    else if (245 <= frequency && frequency <= 250)
      ret = "1옥타브 시";
    else if (260 <= frequency && frequency <= 265)
      ret = "2옥타브 도";
    else if (290 <= frequency && frequency <= 303)
      ret = "2옥타브 레";
    else if (325 <= frequency && frequency <= 330)
      ret = "2옥타브 미";
    else if (345 <= frequency && frequency <= 350)
      ret = "2옥타브 파";
    else if (390 <= frequency && frequency <= 395)
      ret = "2옥타브 솔";
    else if (438 <= frequency && frequency <= 443)
      ret = "2옥타브 라";
    else if (492 <= frequency && frequency <= 497)
      ret = "2옥타브 시";
    else if (520 <= frequency && frequency <= 525)
      ret = "3옥타브 도";
    else if (585 <= frequency && frequency <= 590)
      ret = "3옥타브 레";
    else if (655 <= frequency && frequency <= 670)
      ret = "3옥타브 미";
    else if (695 <= frequency && frequency <= 700)
      ret = "3옥타브 파";
    else if (780 <= frequency && frequency <= 785)
      ret = "3옥타브 솔";
    else if (880 <= frequency && frequency <= 885)
      ret = "3옥타브 라";
    else if (985 <= frequency && frequency <= 990) ret = "3옥타브 시";

    return ret;
  }

  var pitchIdx = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.black),
          title: Text(
            '음역대 측정',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight * 0.1,
              ),
              Text(
                '주의 사항',
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: SizeConfig.defaultSize,
              ),
              Text(
                '혼자 있는 곳 또는 노래방에서 테스트하세요',
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: SizeConfig.defaultSize * 0.5,
              ),
              Text(
                '가성이 아닌 진성으로 부르기!',
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.1,
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  height: SizeConfig.screenHeight / 3,
                  width: SizeConfig.screenWidth * 0.8,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            )),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  pitchItemList[pitchIdx].pitchName,
                                  style: TextStyle(
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  pitchItemList[pitchIdx].pitchCode,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.defaultSize,
                                ),
                                (flag == 0)
                                    ? Text(
                                        "재생버튼을 눌러주세요",
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : (flag == 1)
                                        ? Text(
                                            "음을 측정 중입니다...",
                                            style:
                                                TextStyle(color: Colors.amber),
                                          )
                                        : Column(
                                            children: [
                                              Text(
                                                "성공입니다!",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                              Text(
                                                "아래 버튼을 눌러 다음 단계로 이동하세요!",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                SizedBox(
                                  height: SizeConfig.defaultSize,
                                ),
                                Text(
                                  "현재 측정되는 음",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  frequencyToPitch(),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: kTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.defaultSize,
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      nowPitchName =
                                          pitchItemList[pitchIdx].pitchName;
                                    });
                                    play(pitchItemList[pitchIdx].pitchCode);
                                  },
                                  child: Icon(
                                    Icons.play_circle_outline_outlined,
                                    color: Colors.black,
                                    size: 40.0,
                                  ),
                                ),
                                if (flag == 2)
                                  TextButton(
                                    onPressed: () {
                                      _stopCapture();
                                      setState(() {
                                        ret = "";
                                        pitchIdx++;
                                        flag = 0;
                                      });
                                    },
                                    child: Text(
                                      '다음 음정',
                                      style: TextStyle(
                                        color: Color(0xFF7B61FF),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                if (flag == 1)
                                  TextButton(
                                    onPressed: () {
                                      //최종결과 page route
                                      Navigator.push(
                                        context,
                                        CustomPageRoute(
                                          child: PitchResult(
                                              fitchLevel:
                                                  pitchItemList[pitchIdx].id),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      '더 이상 안올라가요!',
                                      style: TextStyle(
                                        color: Color(0xFF7B61FF),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                              ]),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}
