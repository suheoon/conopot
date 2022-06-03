import 'package:conopot/components/custom_page_route.dart';
import 'package:conopot/constants.dart';
import 'package:conopot/models/FitchItem.dart';
import 'package:conopot/models/MusicSearchItemLists.dart';
import 'package:conopot/models/NavItem.dart';
import 'package:conopot/screens/chart/components/fitchSearchList.dart';
import 'package:conopot/screens/chart/fitch_screen.dart';
import 'package:conopot/screens/home/home_screen.dart';
import 'package:conopot/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class FitchResult extends StatefulWidget {
  FitchResult({Key? key, required this.fitchLevel}) : super(key: key);

  final int fitchLevel;

  @override
  State<FitchResult> createState() => _FitchResultState(fitchLevel);
}

class _FitchResultState extends State<FitchResult> {
  final int fitchLevel;

  _FitchResultState(this.fitchLevel);

  @override
  void initState() {
    setUserFitch();
    super.initState();
  }

  Future<void> setUserFitch() async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'userPitch', value: fitchLevel.toString());

    Future.delayed(Duration.zero, () {
      Provider.of<MusicSearchItemLists>(context, listen: false)
          .changeUserFitch(pitch: fitchLevel);
    });

    Future.delayed(Duration.zero, () {
      Provider.of<MusicSearchItemLists>(context, listen: false)
          .initFitchMusic(fitchNum: fitchLevel);
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
                '내 최고음 구간',
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: SizeConfig.defaultSize,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    FitchNumToString[(fitchLevel - 3 < 1) ? 1 : fitchLevel - 3],
                    style: TextStyle(
                      color: Color(0xFF7B61FF),
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.defaultSize,
                  ),
                  Text(
                    FitchNumToString[fitchLevel],
                    style: TextStyle(
                      color: Color(0xFF7B61FF),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.defaultSize,
              ),
              Text(
                '대한민국 평균 음역대',
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 18,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '2옥타브 솔',
                    style: TextStyle(
                      color: Color(0xFF7B61FF),
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.defaultSize,
                  ),
                  Text(
                    '2옥타브 라',
                    style: TextStyle(
                      color: Color(0xFF7B61FF),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '3옥타브 레',
                    style: TextStyle(
                      color: Color(0xFF7B61FF),
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.defaultSize,
                  ),
                  Text(
                    '3옥타브 미',
                    style: TextStyle(
                      color: Color(0xFF7B61FF),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              //내 음역대의 인기곡들
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  children: [
                    TextSpan(
                      text: '내 ',
                      style: TextStyle(
                        color: kTextColor,
                      ),
                    ),
                    TextSpan(
                      text: '음역대',
                      style: TextStyle(
                        color: Color(0xFF7B61FF),
                      ),
                    ),
                    TextSpan(
                      text: '의 인기곡들',
                      style: TextStyle(
                        color: kTextColor,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                height: 1,
              ),
              FitchSearchList(musicList: musicList),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {
            Future.delayed(Duration.zero, () {
              Provider.of<NavItems>(context, listen: false)
                  .changeNavIndex(index: 1);
            }),
            Navigator.push(
              context,
              CustomPageRoute(
                child: FitchScreen(),
              ),
            ),
          },
          icon: Icon(Icons.check_sharp),
          label: Text('내 음역대에 맞는 노래 찾으러 가기'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
