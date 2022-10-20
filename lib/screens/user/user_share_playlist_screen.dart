import 'dart:convert';
import 'dart:io';
import 'package:conopot/screens/user/user_feed_detail_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:conopot/config/constants.dart';
import 'package:conopot/config/size_config.dart';
import 'package:conopot/models/note_data.dart';
import 'package:conopot/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class UserSharePlaylistScreen extends StatefulWidget {
  UserSharePlaylistScreen({super.key});

  @override
  State<UserSharePlaylistScreen> createState() =>
      _UserSharePlaylistScreenState();
}

class _UserSharePlaylistScreenState extends State<UserSharePlaylistScreen> {
  bool _isLoading = false;
  List<Post> _posts = [];
  var _emotionList = ["😀", "🥲", "😡", "😳", "🫠"];
  int userId = 0;
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;

  @override
  void initState() {
    userId = Provider.of<NoteData>(context, listen: false).userId;
    _firstLoad();
    super.initState();
  }

  //AdMob
  Map<String, String> App_Quit_Banner_UNIT_ID = kReleaseMode
      ? {
          //release 모드일때 (실기기 사용자)
          'android': 'ca-app-pub-7139143792782560/8735916434',
          'ios': 'ca-app-pub-7139143792782560/5121811348',
        }
      : {
          'android': 'ca-app-pub-3940256099942544/6300978111',
          'ios': 'ca-app-pub-3940256099942544/2934735716',
        };

  // TODO: Add _bannerAd
  BannerAd? _bannerAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();
  }

  Future<void> _loadAd() async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    _anchoredAdaptiveAd = BannerAd(
      // TODO: replace with your own ad unit.
      adUnitId: App_Quit_Banner_UNIT_ID[Platform.isIOS ? 'ios' : 'android']!,
      size: size!,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      appBar: AppBar(
          title: Text("내가 공유한 플레이리스트",
              style: TextStyle(color: kPrimaryWhiteColor)),
          centerTitle: false),
      body: ListView(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_anchoredAdaptiveAd != null && _isLoaded)
                  Container(
                    color: Colors.transparent,
                    width: _anchoredAdaptiveAd!.size.width.toDouble(),
                    height: _anchoredAdaptiveAd!.size.height.toDouble(),
                    child: AdWidget(ad: _anchoredAdaptiveAd!),
                  )
              ],
            ),
            decoration: BoxDecoration(
                color: kPrimaryLightBlackColor,
                borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
          SizedBox(height: defaultSize),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _posts.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            UserFeedDetailScreen(post: _posts[index])))
                  ..then((value) {
                    _posts = [];
                    _firstLoad();
                    setState(() {});
                  });
              },
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntrinsicWidth(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultSize * 1.2),
                        child: Row(children: [
                          (_posts[index].userImage == null)
                              ? Container(
                                  width: defaultSize * 2.8,
                                  height: defaultSize * 2.8,
                                  child: SvgPicture.asset(
                                      "assets/icons/profile.svg"),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: SizedBox(
                                      width: defaultSize * 2.8,
                                      height: defaultSize * 2.8,
                                      child: Image.network(
                                          _posts[index].userImage!,
                                          fit: BoxFit.cover))),
                          SizedBox(width: defaultSize * 0.5),
                          Text(
                            "${_posts[index].userName}",
                            style: TextStyle(color: kPrimaryWhiteColor),
                          ),
                          Text("님의 노래방")
                        ]),
                      ),
                    ),
                    SizedBox(height: defaultSize),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          defaultSize, 0, defaultSize, defaultSize),
                      padding: EdgeInsets.all(defaultSize * 1.5),
                      decoration: BoxDecoration(
                          color: kPrimaryLightBlackColor,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: IntrinsicHeight(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: defaultSize),
                              Row(
                                children: [
                                  Text(
                                      "${_emotionList[_posts[index].postIconId]}",
                                      style:
                                          TextStyle(fontSize: defaultSize * 3)),
                                  SizedBox(width: defaultSize),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_posts[index].postTitle,
                                          style: TextStyle(
                                              color: kPrimaryWhiteColor,
                                              overflow: TextOverflow.ellipsis)),
                                      SizedBox(height: defaultSize * 0.25),
                                      Text(
                                        _posts[index].postSubscription == null
                                            ? ""
                                            : _posts[index].postSubscription!,
                                        style: TextStyle(
                                            color: kPrimaryWhiteColor,
                                            overflow: TextOverflow.ellipsis),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: defaultSize),
                              Container(
                                margin:
                                    EdgeInsets.only(left: defaultSize * 0.5),
                                child: Row(
                                  children: [
                                    Icon(Icons.favorite, color: kMainColor),
                                    SizedBox(width: defaultSize * 0.5),
                                    Text(
                                      "${_posts[index].postLikeCount}",
                                      style: TextStyle(color: kMainColor),
                                    ),
                                    Spacer(),
                                    Text(
                                        "${_posts[index].postMusicList.length}개의 노래",
                                        style: TextStyle(
                                            color: kPrimaryLightGreyColor))
                                  ],
                                ),
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _firstLoad() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String URL = 'http://10.0.2.2:3000/playlist/mylist?userId=${userId}';
      final response = await http.get(
        Uri.parse(URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var data = json.decode(response.body);
      setState(() {
        for (var e in data['posts']) {
          _posts.add(Post.fromJson(e));
        }
      });
    } on SocketException {
      // 에러처리 (인터넷 연결 등등)
      EasyLoading.showError("인터넷 연결을 확인해주세요");
    }
    setState(() {
      _isLoading = false;
    });
  }
}
