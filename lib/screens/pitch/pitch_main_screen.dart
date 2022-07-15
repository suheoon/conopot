import 'package:conopot/components/custom_page_route.dart';
import 'package:conopot/config/constants.dart';
import 'package:conopot/models/music_search_item_lists.dart';
import 'package:conopot/screens/pitch/pitch_choice.dart';
import 'package:conopot/screens/pitch/pitch_measure.dart';
import 'package:conopot/config/size_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class PitchMainScreen extends StatefulWidget {
  PitchMainScreen({Key? key}) : super(key: key);

  @override
  State<PitchMainScreen> createState() => _PitchMainScreenState();
}

class _PitchMainScreenState extends State<PitchMainScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "음역대 측정",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context); //뒤로가기
          },
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: SizeConfig.screenHeight / 15,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(
                  child: PitchMeasure(),
                ),
              );
            },
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(top: 30.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  width: SizeConfig.screenWidth * 0.65,
                  height: SizeConfig.screenHeight * 0.25,
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: SizeConfig.screenHeight * 0.15,
                          height: SizeConfig.screenHeight * 0.15,
                          child: FittedBox(
                            child: SvgPicture.asset(
                              'assets/icons/test2.svg',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.defaultSize,
                        ),
                        Text(
                          '크게 소리낼 수 있는 환경에서',
                          style: TextStyle(
                            color: kTextLightColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '직접 음역대 측정해보기',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kTextColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight / 20,
          ),
          GestureDetector(
            onTap: () {
              Provider.of<MusicSearchItemLists>(context, listen: false)
                  .initFitch();
              Navigator.push(
                context,
                CustomPageRoute(
                  child: PitchChoice(),
                ),
              );
            },
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(top: 30.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  width: SizeConfig.screenWidth * 0.65,
                  height: SizeConfig.screenHeight * 0.25,
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: SizeConfig.screenHeight * 0.15,
                          height: SizeConfig.screenHeight * 0.15,
                          child: FittedBox(
                            child: SvgPicture.asset(
                              'assets/icons/test1.svg',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.defaultSize,
                        ),
                        Text(
                          '불러 본 노래 바탕으로',
                          style: TextStyle(
                            color: kTextLightColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '내 음역대 찾기',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kTextColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
