import 'package:conopot/firebase/analytics_config.dart';
import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/models/music_search_item.dart';
import 'package:conopot/global/recommendation_item_list.dart';
import 'package:conopot/screens/recommend/recommendation_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SeasonRecommendation extends StatelessWidget {
  double defaultSize = SizeConfig.defaultSize;
  List<String> titleList = ['봄', '여름', '가을', '겨울'];
  List<List<MusicSearchItem>> songList = [
    RecommendationItemList.springList,
    RecommendationItemList.summerList,
    RecommendationItemList.fallList,
    RecommendationItemList.winterList,
  ];

    List<String> _images = [
    'assets/icons/5-1.svg',
    'assets/icons/5-2.svg',
    'assets/icons/5-3.svg',
    'assets/icons/5-4.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('계절',
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
                    switch(index) {
                      case 0:
                        //event!: 추천_뷰__봄
                        Analytics_config().clickSpringRecommendationEvent();
                        break;
                      case 1:
                        //event!: 추천_뷰__여름
                        Analytics_config().clickSummerRecommendationdEvent();
                        break;
                      case 2:
                        //event!: 추천_뷰__가을
                        Analytics_config().clickFallRecommendationEvent();
                        break;
                      case 3:
                        //event!: 추천_뷰__겨울
                        Analytics_config().clickWinterRecommendationEvent();
                        break;
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecommendationDetailScreen(
                                title: titleList[index],
                                songList: songList[index])));
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: defaultSize * 2),
                    width: defaultSize * 11,
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: FittedBox(
                              fit: BoxFit.fill,
                              child: SvgPicture.asset(
                                _images[index],
                                width: defaultSize * 11,
                                height: defaultSize * 11,
                              )),
                        ),
                      ],
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
