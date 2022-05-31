import 'package:conopot/components/bottom_nav_bar.dart';
import 'package:conopot/constants.dart';
import 'package:conopot/models/MusicSearchItemLists.dart';
import 'package:conopot/screens/fitch/fitchMeasure.dart';
import 'package:conopot/screens/fitch/fitchChoice.dart';
import 'package:conopot/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<MusicSearchItemLists>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: SizeConfig.screenHeight / 5,
          ),
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
                  text: '를 알고있나요?',
                  style: TextStyle(
                    color: kTextColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.defaultSize,
          ),
          Text(
            '음역대란 사람이 낼 수 있는',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 13,
              color: Color(0xFF4F4F4F),
            ),
          ),
          SizedBox(
            height: SizeConfig.defaultSize,
          ),
          Text(
            '최저음부터 최고음까지의 범위를 말합니다.',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 13,
              color: Color(0xFF4F4F4F),
            ),
          ),
          SizedBox(
            height: SizeConfig.defaultSize * 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FitchMeasure(),
                ),
              );
            },
            child: Card(
              color: Colors.white,
              elevation: 2,
              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: SizedBox(
                width: SizeConfig.screenWidth * 0.9,
                height: SizeConfig.screenHeight * 0.15,
                child: Center(
                  child: ListTile(
                    leading: SvgPicture.asset('assets/icons/homeSpeak.svg'),
                    title: Text(
                      '직접 음역대 측정해볼래요!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('크게 소리낼 수 있는 환경에서 추천'),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FitchChoice(),
                ),
              );
            },
            child: Card(
              color: Colors.white,
              elevation: 2,
              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: SizedBox(
                width: SizeConfig.screenWidth * 0.9,
                height: SizeConfig.screenHeight * 0.15,
                child: Center(
                  child: ListTile(
                    leading: SvgPicture.asset('assets/icons/homeUnSpeak.svg'),
                    title: Text(
                      '이 노래 불러봤어요!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('불러본 노래 바탕으로 내 음역대 찾기'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
