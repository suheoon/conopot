import 'dart:async';

import 'package:conopot/constants.dart';
import 'package:conopot/models/MusicSearchItemLists.dart';
import 'package:conopot/screens/home/home_screen.dart';
import 'package:conopot/screens/home/main_screen.dart';
import 'package:conopot/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<MusicSearchItemLists>(context, listen: false).init();
    });

    Timer(Duration(milliseconds: 3000), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.screenHeight * 0.3,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image(
              image: AssetImage('assets/images/splash.png'),
              width: SizeConfig.screenWidth * 0.4,
            ),
          ),
          SizedBox(
            height: SizeConfig.defaultSize * 5,
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              children: [
                TextSpan(
                  text: '오늘은 ',
                  style: TextStyle(
                    color: kTextColor,
                  ),
                ),
                TextSpan(
                  text: '어떤 노래',
                  style: TextStyle(
                    color: Color(0xFF7B61FF),
                  ),
                ),
                TextSpan(
                  text: ' 부르지?',
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
          Text(
            '내 음역대를 바탕으로 보여주는',
            style: TextStyle(
              color: kTextLightColor,
              fontSize: 15,
            ),
          ),
          SizedBox(
            height: SizeConfig.defaultSize * 0.5,
          ),
          Text(
            '내가 부르기 좋은 노래',
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    ));
  }
}
