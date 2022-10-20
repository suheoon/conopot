import 'dart:convert';
import 'dart:io';

import 'package:conopot/config/constants.dart';
import 'package:conopot/config/size_config.dart';
import 'package:conopot/models/note_data.dart';
import 'package:conopot/models/post.dart';
import 'package:conopot/screens/feed/feed_detail_screen.dart';
import 'package:conopot/screens/feed/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PostListView extends StatefulWidget {
  final FeedScrrenController controller;
  PostListView({super.key, required this.controller});

  @override
  State<PostListView> createState() => _PostListViewState(controller);
}

class _PostListViewState extends State<PostListView> {
  double defaultSize = SizeConfig.defaultSize;
  int _lastPostId = 0;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List<Post> _posts = [];
  int _option = 1; // 인기 or 최신
  late ScrollController _controller;
  int userId = 0;
  var _emotionList = ["😀", "🥲", "😡", "😳", "🫠"];

  _PostListViewState(FeedScrrenController _controller) {
    _controller.lastPostId = _lastPostId;
    _controller.loadMore = _loadMore;
  }

  @override
  void initState() {
    super.initState();
    userId = Provider.of<NoteData>(context, listen: false).userId;
    _firstLoad(_option);
    _controller = ScrollController()
      ..addListener(() {
        if (_hasNextPage == true &&
            _isFirstLoadRunning == false &&
            _isLoadMoreRunning == false &&
            _controller.position.maxScrollExtent ==
                _controller.position.pixels) {
          _loadMore(_option);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: defaultSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  setState(() {
                    if (_option == 2) {
                      _option = 1;
                      _posts = [];
                      _lastPostId = 0;
                      _firstLoad(_option);
                    }
                  });
                },
                child: _option == 1
                    ? Container(
                        padding: EdgeInsets.fromLTRB(defaultSize,
                            defaultSize * 0.5, defaultSize, defaultSize * 0.5),
                        decoration: BoxDecoration(
                            color: kMainColor.withOpacity(0.8),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: Text(
                          "인기",
                          style: TextStyle(color: kPrimaryWhiteColor),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.fromLTRB(defaultSize,
                            defaultSize * 0.5, defaultSize, defaultSize * 0.5),
                        child: Text(
                          "인기",
                          style: TextStyle(color: kPrimaryWhiteColor),
                        ),
                      ),
              ),
              SizedBox(
                width: defaultSize * 0.5,
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    if (_option == 1) {
                      _option = 2;
                      _posts = [];
                      _lastPostId = 0;
                      _firstLoad(_option);
                    }
                  });
                },
                child: _option == 2
                    ? Container(
                        padding: EdgeInsets.fromLTRB(defaultSize,
                            defaultSize * 0.5, defaultSize, defaultSize * 0.5),
                        decoration: BoxDecoration(
                            color: kMainColor.withOpacity(0.8),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: Text(
                          "최신",
                          style: TextStyle(color: kPrimaryWhiteColor),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.fromLTRB(defaultSize,
                            defaultSize * 0.5, defaultSize, defaultSize * 0.5),
                        child: Text(
                          "최신",
                          style: TextStyle(color: kPrimaryWhiteColor),
                        ),
                      ),
              ),
            ],
          ),
        ),
        SizedBox(height: defaultSize * 1.5),
        _isFirstLoadRunning
            ? const Center(
                child: CircularProgressIndicator(
                  backgroundColor: kMainColor,
                  valueColor: AlwaysStoppedAnimation<Color>(kBackgroundColor),
                  value: 0.4,
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                controller: _controller,
                itemCount: _posts.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () async {
                    final result = await
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => FeedDetailScreen(
                                  post: _posts[index],
                                )));
                    if (result) {
                      _posts[index].postLikeCount += 1;
                      setState(() {});
                    } else {
                      _posts[index].postLikeCount -= 1;
                      setState(() {});
                    }
                  },
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IntrinsicWidth(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: defaultSize * 1.2),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: IntrinsicHeight(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: defaultSize),
                                  Row(
                                    children: [
                                      Text(
                                          "${_emotionList[_posts[index].postIconId]}",
                                          style: TextStyle(
                                              fontSize: defaultSize * 3)),
                                      SizedBox(width: defaultSize),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(_posts[index].postTitle,
                                              style: TextStyle(
                                                  color: kPrimaryWhiteColor,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                          SizedBox(height: defaultSize * 0.25),
                                          Text(
                                            _posts[index].postSubscription ==
                                                    null
                                                ? ""
                                                : _posts[index]
                                                    .postSubscription!,
                                            style: TextStyle(
                                                color: kPrimaryWhiteColor,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: defaultSize),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: defaultSize * 0.5),
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
              ),
        if (_isLoadMoreRunning == true)
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 40),
            child: Center(
              child: CircularProgressIndicator(
                  backgroundColor: kMainColor,
                  valueColor: AlwaysStoppedAnimation<Color>(kBackgroundColor),
                  value: 0.4,
                ),
            ),
          ),
        if (_hasNextPage == false)
          Container(
            color: Colors.amber,
            child: const Center(
              child: Text(
                "더 이상 게시물이 없습니다",
                style: TextStyle(color: kPrimaryLightWhiteColor),
              ),
            ),
          ),
      ],
    );
  }

  // 최초로 인기 게시물을 불러오는 함수
  void _firstLoad(int option) async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      // option = 1 인기순, option = 2 최신순
      String URL = (option == 1)
          ? 'http://10.0.2.2:3000/post/sort/famous?postId=${_lastPostId}&userId=${userId}'
          : 'http://10.0.2.2:3000/post/sort/latest?postId=${_lastPostId}&userId=${userId}';
      final response = await http.get(
        Uri.parse(URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var data = json.decode(response.body);
      print(data);
      setState(() {
        _lastPostId = data['lastPostId'];
        for (var e in data['posts']) {
          _posts.add(Post.fromJson(e));
        }
      });
    } on SocketException {
      // 에러처리 (인터넷 연결 등등)
      EasyLoading.showError("인터넷 연결을 확인해주세요");
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  // 추가적인 게시물을 불러오는 함수
  void _loadMore(int option) async {
    setState(() {
      // api 호출시 List Veiew의 하단에 Loading Indicator를 띄운다.
      _isLoadMoreRunning = true;
    });
    try {
      String URL = (option == 1)
          ? 'http://10.0.2.2:3000/post/sort/famous?postId=${_lastPostId}&userId=${userId}'
          : 'http://10.0.2.2:3000/post/sort/latest?postId=${_lastPostId}&userId=${userId}';
      final response = await http.get(
        Uri.parse(URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var data = json.decode(response.body);
      // 새로 받아온 게시물
      final List fetchedPosts = data['posts'];
      if (fetchedPosts.isNotEmpty) {
        setState(() {
          _lastPostId = data['lastPostId'];
          for (var e in fetchedPosts) {
            _posts.add(Post.fromJson(e));
          }
        });
      } else {
        // 게시물이 더 이상 없을 때
        setState(() {
          _hasNextPage = false;
        });
      }
    } catch (err) {
      // 에러 처리 (인터넷 연결 에러 등등)
    }
    setState(() {
      _isLoadMoreRunning = false;
    });
  }
}
