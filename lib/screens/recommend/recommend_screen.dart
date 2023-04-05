import 'package:conopot/firebase/analytics_config.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/models/music_state.dart';
import 'package:conopot/models/note_state.dart';
import 'package:conopot/screens/recommend/components/contextual_recommendation.dart';
import 'package:conopot/screens/recommend/components/customize_recommendation.dart';
import 'package:conopot/screens/recommend/components/gender_recommendation.dart';
import 'package:conopot/screens/recommend/components/genre_recommendation.dart';
import 'package:conopot/screens/recommend/components/pitch_detection_banner.dart';
import 'package:conopot/screens/recommend/components/popular_song_recommendation.dart';
import 'package:conopot/screens/recommend/components/season_recommendation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class RecommendScreen extends StatefulWidget {
  const RecommendScreen({Key? key}) : super(key: key);

  @override
  State<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  double defaultSize = SizeConfig.defaultSize;

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = SizeConfig.screenHeight;
    //!evnet:  추천_뷰__페이지뷰
    Analytics_config().recommendationPageVeiwEvent;

    return Consumer<MusicState>(
      builder: (
        context,
        musicList,
        child,
      ) =>
          Scaffold(
        appBar: AppBar(
          title: Text("추천", style: TextStyle(fontWeight: FontWeight.w700)),
          centerTitle: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: screenHeight * 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PitchDetectionBanner(
                  musicList: musicList,
                  notes: Provider.of<NoteState>(context, listen: true).notes,
                ), // 음역대 측정하기 버튼 배너
                SizedBox(height: defaultSize * 2),
                CustomizeRecommendation(
                  musicList: musicList,
                  notes: Provider.of<NoteState>(context, listen: true).notes,
                ), // 맞춤 추천
                SizedBox(height: defaultSize * 2),
                PopularSongRecommendation(), // 인기 추천
                SizedBox(height: defaultSize * 2),
                ContextualRecommendation(), // 상황별 추천
                SizedBox(height: defaultSize * 2),
                GenreRecommendation(), // 장르 추천
                SizedBox(height: defaultSize * 2),
                GenderRecommendation(), // 성별 추천
                SizedBox(height: defaultSize * 2),
                SeasonRecommendation(), // 계절별 추천
              ],
            ),
          ),
        ),
      ),
    );
  }
}
