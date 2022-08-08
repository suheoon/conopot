import 'package:conopot/config/constants.dart';
import 'package:conopot/config/size_config.dart';
import 'package:conopot/models/music_search_item.dart';
import 'package:conopot/models/recommendation_item_list.dart';
import 'package:conopot/screens/recommend/recommendation_detail_screen.dart';
import 'package:flutter/material.dart';

class ContextualRecommendation extends StatelessWidget {
  double defaultSize = SizeConfig.defaultSize;
  List<String> titleList = ['여심저격', '커플 끼리', '분위기 UP', '지치고 힘들 때', '비올때'];
  List<List<MusicSearchItem>> songList = [
    RecommendationItemList.loveList,
    RecommendationItemList.duetList,
    RecommendationItemList.excitedList,
    RecommendationItemList.tiredList,
    RecommendationItemList.rainList
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
                              child: Image.asset(
                                "assets/images/recommend1.png",
                                width: defaultSize * 11,
                                height: defaultSize * 11,
                              )),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                              titleList[index],
                              style: TextStyle(
                                  color: kPrimaryWhiteColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: defaultSize * 1.5),
                            )),
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