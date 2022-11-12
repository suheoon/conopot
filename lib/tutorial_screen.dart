import 'package:conopot/config/size_config.dart';
import 'package:conopot/tutorial_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TutorialScreen extends StatelessWidget {
  TutorialScreen({Key? key}) : super(key: key);

  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      controller: controller,
      // physics: NeverScrollableScrollPhysics(),
      children: [
        TutorialPage(
          image: SvgPicture.asset(
            "assets/icons/tutorial1.svg",
          ),
          noOfScreen: 4,
          onNextPressed: changeScreen,
          currentScreenNo: 0,
        ),
        TutorialPage(
          image: SvgPicture.asset(
            "assets/icons/tutorial2.svg",
          ),
          noOfScreen: 4,
          onNextPressed: changeScreen,
          currentScreenNo: 1,
        ),
        TutorialPage(
          image: SvgPicture.asset(
            "assets/icons/tutorial3.svg",
          ),
          noOfScreen: 4,
          onNextPressed: changeScreen,
          currentScreenNo: 2,
        ),
        TutorialPage(
          image: SvgPicture.asset(
            "assets/icons/tutorial4.svg",
          ),
          noOfScreen: 4,
          onNextPressed: changeScreen,
          currentScreenNo: 3,
        ),
      ],
    ));
  }

  changeScreen(int nextScreenNo) {
    controller.animateToPage(nextScreenNo,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }
}
