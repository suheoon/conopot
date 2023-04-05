import 'dart:convert';
import 'package:conopot/models/user_state.dart';
import 'package:conopot/screens/feed/song_detail_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:conopot/firebase/analytics_config.dart';
import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/models/music_state.dart';
import 'package:conopot/models/note.dart';
import 'package:conopot/models/note_state.dart';
import 'package:conopot/screens/recommend/customize_recommendation_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomizeRecommendation extends StatefulWidget {
  late MusicState musicList;
  late List<Note> notes;
  CustomizeRecommendation(
      {Key? key, required this.musicList, required this.notes})
      : super(key: key);

  @override
  State<CustomizeRecommendation> createState() =>
      _CustomizeRecommendationState();
}

// 맞춤 추천
class _CustomizeRecommendationState extends State<CustomizeRecommendation> {
  double defaultSize = SizeConfig.defaultSize;
  final storage = new FlutterSecureStorage();

  void requestCFApi() async {
    Provider.of<UserState>(context, listen: false).recommendRequest = true;
    storage.write(key: "recommendRequest", value: 'true');
    await EasyLoading.show();
    String url = 'https://recommendcf-pfenq2lbpq-du.a.run.app/recommendCF';
    List<String> musicArr =
        Provider.of<NoteState>(context, listen: false).userMusics;
    if (musicArr.length > 20) {
      // 저장한 노트수가 20개 보다 많은 경우 자르기
      musicArr = musicArr.sublist(0, 20);
    }
    Future<dynamic> myFuture = new Future(() async {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"musicArr": musicArr.toString()}),
      );
      return response;
    });
    myFuture.then((response) {
      if (response.statusCode == 200) {
        String? recommendList = response.body;
        if (recommendList != null) {
          widget.musicList.saveAiRecommendationList(recommendList);
          EasyLoading.showSuccess('분석에 성공했습니다!');
        } else {
          EasyLoading.showToast('분석을 위한 데이터가 부족합니다\n노트를 좀더 추가해주세요');
        }
      } else {
        EasyLoading.showToast('서버 문제가 발생했습니다\n채널톡에 문의해주세요');
      }
    }, onError: (e) {
      EasyLoading.showToast('분석에 실패했습니다\n인터넷 연결을 확인해 주세요');
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.5),
          child: Row(
            children: [
              Text("AI 추천",
                  style: TextStyle(
                      color: kPrimaryWhiteColor,
                      fontSize: defaultSize * 2,
                      fontWeight: FontWeight.w600)),
              Spacer(),
              if (widget.musicList.aiRecommendationList.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    //!event: 추천_뷰__AI추천_노트추가하러가기
                    Analytics_config().clickAINoteAddRecommendationEvent();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CustomizeRecommendationDetailScreen(
                                    musicList: widget.musicList,
                                    title: "AI 추천",
                                    songList: Provider.of<MusicState>(context,
                                            listen: true)
                                        .aiRecommendationList)));
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        defaultSize * 0.8,
                        defaultSize * 0.5,
                        defaultSize * 0.8,
                        defaultSize * 0.5),
                    decoration: BoxDecoration(
                        color: kMainColor,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Text("더보기",
                        style: TextStyle(
                            color: kPrimaryWhiteColor,
                            fontSize: defaultSize,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: defaultSize * 2),
        if (widget.notes.length < 5 &&
            Provider.of<UserState>(context, listen: false).sessionCount ==
                false) ...[
          // 저장한 노트 개수가 5개 미만일 때
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.25),
            padding: EdgeInsets.symmetric(vertical: defaultSize * 3),
            decoration: BoxDecoration(
                color: kPrimaryLightBlackColor,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Column(
              children: [
                Center(
                    child: Text("분석을 위해 노래를 최소 5개이상 추가해주세요 😸",
                        style: TextStyle(
                            color: kPrimaryWhiteColor,
                            fontWeight: FontWeight.w400,
                            fontSize: defaultSize * 1.5))),
              ],
            ),
          )
        ] else if (widget.notes.length >= 5 &&
            Provider.of<UserState>(context, listen: false).sessionCount ==
                false) ...[
          // 저장한 노트 개수가 5개 이상이지만 호출을 하지 않았을 때
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.25),
            padding: EdgeInsets.symmetric(vertical: defaultSize * 3),
            decoration: BoxDecoration(
                color: kPrimaryLightBlackColor,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Center(
                child: Column(
              children: [
                Text("AI분석을 요청해보세요 😼",
                    style: TextStyle(
                        color: kPrimaryWhiteColor,
                        fontWeight: FontWeight.w400,
                        fontSize: defaultSize * 1.5)),
                SizedBox(height: defaultSize * 1.5),
                GestureDetector(
                  onTap: () {
                    //!event: 추천_뷰__AI추천받기
                    Analytics_config().clickAIRecommendationEvent();
                    requestCFApi();
                    setState(() {});
                    //전면 광고
                    Provider.of<NoteState>(context, listen: false)
                        .aiInterstitialAd();
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(defaultSize * 1.5, defaultSize,
                        defaultSize * 1.5, defaultSize),
                    decoration: BoxDecoration(
                        color: kMainColor,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Text(
                      "AI분석 요청하기",
                      style: TextStyle(
                          color: kPrimaryWhiteColor,
                          fontSize: defaultSize * 1.3,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            )),
          )
        ] else if (Provider.of<UserState>(context, listen: false)
                    .recommendRequest ==
                true &&
            widget.musicList.aiRecommendationList.isEmpty) ...[
          // api 호출을 했지만 추천을 받지 못했을 때
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.25),
            padding: EdgeInsets.symmetric(vertical: defaultSize * 3),
            decoration: BoxDecoration(
                color: kPrimaryLightBlackColor,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("미안해요 분석을 실패했어요 😹",
                    style: TextStyle(
                        color: kPrimaryWhiteColor,
                        fontWeight: FontWeight.w400,
                        fontSize: defaultSize * 1.5),
                    textAlign: TextAlign.start),
                SizedBox(height: defaultSize),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultSize),
                    child: Text("1. 인터넷 연결을 확인해주세요.",
                        style: TextStyle(
                            color: kPrimaryWhiteColor,
                            fontWeight: FontWeight.w400,
                            fontSize: defaultSize * 1.5),
                        textAlign: TextAlign.start),
                  ),
                ),
                SizedBox(height: defaultSize * 0.25),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultSize),
                    child: Text(
                        "2. 인터넷 연결이 잘 됐지만 결과가 나오지 않는다면 노트를 좀 더 추가한 후에 다시 시도해주세요.",
                        style: TextStyle(
                            color: kPrimaryWhiteColor,
                            fontWeight: FontWeight.w400,
                            fontSize: defaultSize * 1.5),
                        textAlign: TextAlign.start),
                  ),
                ),
                SizedBox(height: defaultSize * 1.5),
                GestureDetector(
                  onTap: () {
                    //!event: 추천_뷰__AI추천받기
                    Analytics_config().clickAIRecommendationEvent();
                    requestCFApi();
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(defaultSize * 1.5, defaultSize,
                        defaultSize * 1.5, defaultSize),
                    decoration: BoxDecoration(
                        color: kMainColor,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Text(
                      "AI분석 요청하기",
                      style: TextStyle(
                          color: kPrimaryWhiteColor,
                          fontSize: defaultSize * 1.3,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          )
        ] else ...[
          Container(
            margin: EdgeInsets.symmetric(horizontal: defaultSize),
            width: double.infinity,
            height: 185,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.musicList.aiRecommendationList.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 60,
                  childAspectRatio: 1 / 3.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 15),
              itemBuilder: (context, index) {
                String songNumber =
                    widget.musicList.aiRecommendationList[index].tj_songNumber;
                String title =
                    widget.musicList.aiRecommendationList[index].tj_title;
                String singer =
                    widget.musicList.aiRecommendationList[index].tj_singer;

                Set<Note> entireNote =
                    Provider.of<MusicState>(context, listen: false).entireNote;
                Note? note;
                for (Note e in entireNote) {
                  if (e.tj_songNumber == songNumber) {
                    note = e;
                  }
                }
                return GestureDetector(
                  onTap: () {
                    if (note != null)
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SongDetailScreen(note: note!)));
                  },
                  child: GridTile(
                    child: Container(
                      padding: EdgeInsets.all(defaultSize),
                      decoration: BoxDecoration(
                          color: kPrimaryLightBlackColor,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                            child: Center(
                              child: Text(
                                "${songNumber}",
                                style: TextStyle(
                                    color: kMainColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: defaultSize),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${title}",
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: kPrimaryWhiteColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11),
                                  ),
                                  Text(
                                    "${singer}",
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: kPrimaryLightWhiteColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 9),
                                  )
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
