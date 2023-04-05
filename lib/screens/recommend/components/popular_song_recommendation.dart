import 'package:conopot/firebase/analytics_config.dart';
import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/models/music_state.dart';
import 'package:conopot/global/recommendation_item_list.dart';
import 'package:conopot/screens/recommend/popular_recommendation_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class PopularSongRecommendation extends StatelessWidget {
  double defaultSize = SizeConfig.defaultSize;
  List<String> _list = ['TJ 인기차트', '금영 인기차트', '올타임 레전드'];
  List<String> _images = ['assets/icons/1-1.svg','assets/icons/1-2.svg', 'assets/icons/1-3.svg'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('인기',
              style: TextStyle(
                  color: kPrimaryWhiteColor,
                  fontSize: defaultSize * 2,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: defaultSize * 2),
          Container(
            height: defaultSize * 11,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      //!event: 추천_뷰___TJ_인기차트
                      Analytics_config().clickTJChartEvent();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PopularRecommendationDetailScreen(
                                      title: _list[index],
                                      songList:
                                          Provider.of<MusicState>(
                                                  context,
                                                  listen: false)
                                              .tjChartSongList)));
                    } else if (index == 1) {
                      //!event: 추천_뷰__금영_인기차트
                      Analytics_config().clickKYChartEvent();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PopularRecommendationDetailScreen(
                                      title: _list[index],
                                      songList:
                                          Provider.of<MusicState>(
                                                  context,
                                                  listen: false)
                                              .kyChartSongList)));
                    } else {
                      //!event: 추천_뷰__올타임_레전드
                      Analytics_config().clickAllTimeLegendRecommendationEvent();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PopularRecommendationDetailScreen(
                                      title: _list[index],
                                      songList: RecommendationItemList
                                          .allTimeLegendList)));
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
