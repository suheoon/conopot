import 'package:conopot/config/constants.dart';
import 'package:conopot/config/size_config.dart';
import 'package:conopot/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';

class TutorialPage extends StatelessWidget {
  TutorialPage(
      {Key? key,
      required this.image,
      this.noOfScreen,
      required this.onNextPressed,
      required this.currentScreenNo})
      : super(key: key);

  final SvgPicture image;

  final noOfScreen;

  final Function(int) onNextPressed;

  final int currentScreenNo;

  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    bool isLastScreen = currentScreenNo >= noOfScreen - 1;

    return Padding(
      padding: EdgeInsets.all(SizeConfig.defaultSize * 1),
      child: Stack(
        children: [
          image,
          Align(
            alignment: Alignment.topRight,
            child: Row(
              children: [
                for (int idx = 0; idx < noOfScreen; idx++)
                  createProgressDots((idx == currentScreenNo) ? true : false)
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Visibility(
              visible: !isLastScreen,
              replacement: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        //"시작하기" 버튼 누를 시, 다음부터는 튜토리얼 화면이 뜨지 않는다.
                        await storage.write(key: 'tutorial', value: '1');
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen()));
                      },
                      child: const Text("시작하기",
                          style: TextStyle(
                              color: kMainColor, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        onNextPressed(currentScreenNo + 1);
                      },
                      child: const Text("다음",
                          style: TextStyle(
                              color: kMainColor, fontWeight: FontWeight.w600)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget createProgressDots(bool isActiveScreen) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: isActiveScreen ? 12 : 7,
      width: isActiveScreen ? 12 : 7,
      decoration: BoxDecoration(
          color: isActiveScreen ? kMainColor : Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}
