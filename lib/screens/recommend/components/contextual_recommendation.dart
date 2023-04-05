import 'package:conopot/firebase/analytics_config.dart';
import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/models/music_search_item.dart';
import 'package:conopot/models/music_state.dart';
import 'package:conopot/global/recommendation_item_list.dart';
import 'package:conopot/screens/recommend/pitch_reommendation_detail_screen.dart';
import 'package:conopot/screens/recommend/recommendation_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ContextualRecommendation extends StatelessWidget {
  double defaultSize = SizeConfig.defaultSize;
  List<String> titleList = [
    '내 음역대',
    '여심저격',
    '커플 끼리',
    '분위기 UP',
    '지치고 힘들 때',
    '비올 때'
  ];
  List<List<MusicSearchItem>> songList = [
    RecommendationItemList.loveList,
    RecommendationItemList.duetList,
    RecommendationItemList.excitedList,
    RecommendationItemList.tiredList,
    RecommendationItemList.rainList
  ];
  List<String> _images = [
    'assets/icons/2-1.svg',
    'assets/icons/2-2.svg',
    'assets/icons/2-3.svg',
    'assets/icons/2-4.svg',
    'assets/icons/2-5.svg',
    'assets/icons/2-6.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('테마',
              style: TextStyle(
                  color: kPrimaryWhiteColor,
                  fontSize: defaultSize * 2,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: defaultSize * 2),
          Container(
            height: defaultSize * 11,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: titleList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    switch (index) {
                      case 0:
                        // 이벤트
                        break;
                      case 1:
                        //!event: 추천_뷰__여심저격
                        Analytics_config().clickLoveRecommendationEvent();
                        break;
                      case 2:
                        //!event: 추천_뷰__커플끼리
                        Analytics_config().clickCoupleRecommendationEvent();
                        break;
                      case 3:
                        //!event: 추천_뷰__분위기UP
                        Analytics_config().clickTensionUpRecommendationEvent();
                        break;
                      case 4:
                        //!event: 추천_뷰__지치고힘들때
                        Analytics_config().clickTiredRecommendationEvent();
                        break;
                      case 5:
                        //!evnet: 추천_뷰__비올 때
                        Analytics_config().clickRainRecommendationEvent();
                        break;
                    }
                    if (index == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PitchRecommendationDetailScreen(
                                      title: titleList[index],
                                      songList:
                                          Provider.of<MusicState>(
                                                  context,
                                                  listen: false)
                                              .customizeRecommendationList)));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecommendationDetailScreen(
                                  title: titleList[index],
                                  songList: songList[index - 1])));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: defaultSize * 2),
                    width: defaultSize * 11,
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: SvgPicture.asset(
                            _images[index],
                            width: defaultSize * 11,
                            height: defaultSize * 11,
                          )),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
