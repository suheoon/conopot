import 'dart:convert';
import 'dart:io';
import 'package:conopot/screens/user/user_feed_edit_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:conopot/models/note.dart';
import 'package:conopot/models/note_state.dart';
import 'package:conopot/screens/feed/components/edit_feed_detail_song_list.dart';
import 'package:conopot/screens/feed/components/feed_detail_song_list.dart';
import 'package:conopot/screens/feed/feed_report_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/models/music_state.dart';
import 'package:conopot/models/post.dart';
import 'package:conopot/screens/note/components/youtube_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class UserFeedDetailScreen extends StatefulWidget {
  Post post;
  UserFeedDetailScreen({super.key, required this.post});

  @override
  State<UserFeedDetailScreen> createState() => _UserFeedDetailScreenState();
}

class _UserFeedDetailScreenState extends State<UserFeedDetailScreen> {
  String? videoId;
  int _index = 0;
  bool _like = false; // 좋아요 여부
  int? _userId;
  var _emotionList = [
    "😀",
    "🥲",
    "😡",
    "😳",
    "😎",
    "🎤",
    "🎁",
    "🧸",
    "🎧",
    "💌"
  ];
  bool _isEditting = false;
  List<Note> postList = [];
  int _checkCount = 0;

  _indexChange(int index) {
    setState(() {
      _index = index;
      videoId = Provider.of<MusicState>(context, listen: false)
          .youtubeURL[widget.post.postMusicList[_index]];
    });
  }

  _checkCountChange(bool val) {
    setState(() {
      if (val == true)
        _checkCount += 1;
      else
        _checkCount -= 1;
    });
  }

  void initPostList() {
    // tjSongNumber 문자열로 돼 있는 리스트를 Note 배열로 변환
    Set<Note> entireNote =
        Provider.of<MusicState>(context, listen: false).entireNote;
    for (int i = 0; i < widget.post.postMusicList.length; i++) {
      Note note = entireNote.firstWhere(
          (element) => element.tj_songNumber == widget.post.postMusicList[i]);
      bool flag = false;
      postList.add(note);
    }
  }

  @override
  void initState() {
    _userId = Provider.of<NoteState>(context, listen: false).userId;
    getLikeInfo().then((result) {
      setState(() {
        if (result == 'true') {
          _like = true;
        } else {
          _like = false;
        }
      });
    });
    videoId = Provider.of<MusicState>(context, listen: false)
        .youtubeURL[widget.post.postMusicList[_index]];
    super.initState();
    initPostList();
  }

  // 사용자가 좋아요여부 대한 정보를 받아오는 함수
  getLikeInfo() async {
    try {
      String? serverURL = dotenv.env['USER_SERVER_URL'];
      String URL =
          '${serverURL}/playlist/heart?userId=${_userId}&postId=${widget.post.postId}';
      final response = await http.get(
        Uri.parse(URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      return response.body;
    } on SocketException {
      // 에러처리 (인터넷 연결 등등)
      EasyLoading.showToast("인터넷 연결을 확인해주세요");
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(defaultSize * 0.5),
          decoration: BoxDecoration(
              color: kPrimaryGreyColor,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: IntrinsicWidth(
            child: Row(
              children: [
                Text("${_emotionList[widget.post.postIconId]} "),
                Expanded(
                  child: Text(
                    "${widget.post.postTitle}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: defaultSize * 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        leading: BackButton(
          color: kPrimaryLightWhiteColor,
          onPressed: () {
            Navigator.pop(context, _like); //뒤로가기
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                showReportListOption(context);
              },
              icon: Icon(
                Icons.more_vert,
                color: kPrimaryWhiteColor,
              ))
        ],
      ),
      floatingActionButton: (_isEditting == false)
          ? GestureDetector(
              onTap: () {
                setState(() {
                  _checkCount = 0;
                  _isEditting = true;
                  Provider.of<NoteState>(context, listen: false)
                      .initAddFeedSong(widget.post.postMusicList);
                });
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(defaultSize, defaultSize * 0.5,
                    defaultSize, defaultSize * 0.5),
                decoration: BoxDecoration(
                    color: kPrimaryGreyColor,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: IntrinsicWidth(
                  child: Row(
                    children: [
                      Icon(Icons.playlist_add, color: kMainColor),
                      SizedBox(width: defaultSize),
                      Text(
                        "내 애창곡 리스트에 추가",
                        style: TextStyle(
                            color: kMainColor, fontSize: defaultSize * 1.3),
                      )
                    ],
                  ),
                ),
              ),
            )
          : IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_checkCount > 0) ...[
                    Text("${_checkCount}개의 곡을 선택했습니다.",
                        style: TextStyle(
                            color: kMainColor, fontSize: defaultSize * 1.3),
                        key: ValueKey(_checkCount))
                  ],
                  SizedBox(height: defaultSize * 0.5),
                  Container(
                    padding: EdgeInsets.fromLTRB(defaultSize * 2,
                        defaultSize * 0.5, defaultSize * 2, defaultSize * 0.5),
                    decoration: BoxDecoration(
                        color: kPrimaryGreyColor,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: IntrinsicHeight(
                      child: IntrinsicWidth(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _checkCount = postList.length;
                                });
                                Provider.of<NoteState>(context, listen: false)
                                    .checkAllFeedSongs(postList);
                              },
                              child: Column(children: [
                                Icon(Icons.list, color: kMainColor),
                                Text(
                                  "전체 선택",
                                  style: TextStyle(
                                      color: kMainColor,
                                      fontSize: defaultSize * 1.1),
                                )
                              ]),
                            ),
                            SizedBox(width: defaultSize),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _checkCount = 0;
                                });
                                Provider.of<NoteState>(context, listen: false)
                                    .uncheckAllFeedSongs();
                              },
                              child: Column(children: [
                                Icon(Icons.playlist_remove, color: kMainColor),
                                Text(
                                  "전체 해제",
                                  style: TextStyle(
                                      color: kMainColor,
                                      fontSize: defaultSize * 1.1),
                                )
                              ]),
                            ),
                            SizedBox(width: defaultSize),
                            GestureDetector(
                              onTap: () {
                                if (_checkCount > 0) {
                                  Provider.of<NoteState>(context, listen: false)
                                      .addMultipleFeedSongs();
                                }
                              },
                              child: Column(children: [
                                Icon(Icons.list,
                                    color: (_checkCount == 0)
                                        ? kPrimaryLightGreyColor
                                        : kPrimaryWhiteColor),
                                Text(
                                  "추가",
                                  style: TextStyle(
                                    color: (_checkCount == 0)
                                        ? kPrimaryLightGreyColor
                                        : kPrimaryWhiteColor,
                                    fontSize: defaultSize * 1.1,
                                  ),
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(children: [
        if (videoId == null) ...[
          Text(
            "유튜브 영상을 지원하지 않는 노래입니다",
            style: TextStyle(color: kMainColor),
          ),
        ] else ...[
          YoutubeVideoPlayer(videoId: videoId!, key: ValueKey(videoId)),
        ],
        SizedBox(height: defaultSize * 2),
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultSize),
                child: GestureDetector(
                  onTap: () async {
                    String? serverURL = dotenv.env['USER_SERVER_URL'];
                    String URL = "";
                    setState(() {
                      if (_like == false) {
                        _like = true;
                        URL = '${serverURL}/playlist/heart';
                      } else {
                        _like = false;
                        URL = '${serverURL}/playlist/hate';
                      }
                    });
                    try {
                      final response = await http.post(
                        Uri.parse(URL),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode({
                          "postId": widget.post.postId,
                          "userId": Provider.of<NoteState>(context, listen: false)
                              .userId,
                        }),
                      );
                    } on SocketException {
                      // 에러처리 (인터넷 연결 등등)
                      EasyLoading.showToast("인터넷 연결을 확인해주세요");
                    }
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(
                          width: defaultSize * 4,
                          height: defaultSize * 4,
                          child: (widget.post.userImage == null)
                              ? Image.asset("assets/images/profile.png")
                              : Image.network(widget.post.userImage!,
                                  fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(width: defaultSize),
                      Text("${widget.post.userName}",
                          style: TextStyle(
                              color: kPrimaryLightWhiteColor,
                              fontSize: defaultSize * 1.5),
                          overflow: TextOverflow.ellipsis),
                      Spacer(),
                      (widget.post.postAuthorId ==
                                  Provider.of<NoteState>(context, listen: false)
                                      .userId &&
                              _isEditting == false)
                          ? SizedBox.shrink()
                          : (_isEditting == false)
                              ? Row(
                                  children: [
                                    (_like == true)
                                        ? Icon(Icons.favorite, color: kMainColor)
                                        : Icon(Icons.favorite_border,
                                            color: kMainColor),
                                    SizedBox(width: defaultSize * 0.3),
                                    Text("좋아요",
                                        style: TextStyle(color: kMainColor))
                                  ],
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isEditting = false;
                                    });
                                  },
                                  child: Text("완료",
                                      style: TextStyle(color: kMainColor))),
                    ],
                  ),
                ),
              ),
               SizedBox(height: defaultSize),
                Container(
                  decoration: BoxDecoration(color: kPrimaryLightBlackColor, borderRadius: BorderRadius.all(Radius.circular(8))),
                  padding: EdgeInsets.all(defaultSize),
                  margin: EdgeInsets.symmetric(horizontal: defaultSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.post.postTitle}",
                          style: TextStyle(
                              color: kPrimaryWhiteColor,
                              fontSize: defaultSize * 1.5)),
                      SizedBox(height: defaultSize * 0.5),
                      Text("${widget.post.postSubscription}",
                          style: TextStyle(
                              color: kPrimaryLightWhiteColor,
                              fontSize: defaultSize * 1.3)),
                    ],
                  ),
                ),
              SizedBox(height: defaultSize),
              (_isEditting == false)
                  ? FeedDetailSongList(
                      postList: postList, indexChange: _indexChange)
                  : EditFeedDetailSongList(
                      postList: postList, checkedCountChange: _checkCountChange)
            ],
          ),
        )
      ]),
    );
  }

  // 신고, 차단 목록 bottom sheet
  showReportListOption(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        backgroundColor: kDialogColor,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: defaultSize * 1.5),
            child: IntrinsicHeight(
              child: Column(children: [
                SizedBox(height: defaultSize),
                Container(
                  height: 5,
                  width: 50,
                  color: kPrimaryLightWhiteColor,
                ),
                SizedBox(height: defaultSize * 3),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Provider.of<NoteState>(context, listen: false).lists =
                        postList;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserFeedEditScreen(post: widget.post),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      SizedBox(width: defaultSize),
                      Text(
                        "수정하기",
                        style: TextStyle(color: kPrimaryWhiteColor),
                      ),
                      Spacer(),
                      Icon(
                        Icons.chevron_right_outlined,
                        color: kPrimaryWhiteColor,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: defaultSize * 1.8),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    // 차단하기
                    showDeleteDialog(context);
                  },
                  child: Row(
                    children: [
                      SizedBox(width: defaultSize),
                      Text(
                        "삭제하기",
                        style: TextStyle(color: kPrimaryWhiteColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: defaultSize * 6.5,
                ),
              ]),
            ),
          );
        });
  }

  // 삭제 여부 확인 다이어로그
  void showDeleteDialog(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    double screenWidth = SizeConfig.screenWidth;

    Widget cancelButton = Container(
      width: screenWidth * 0.3,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kPrimaryGreyColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                side: const BorderSide(width: 0.0),
                borderRadius: BorderRadius.circular(8),
              ))),
          onPressed: () async {
            Navigator.of(context).pop();
          },
          child: Text("취소",
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: kMainColor))),
    );

    Widget blockButton = Container(
      width: screenWidth * 0.3,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kMainColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              side: const BorderSide(width: 0.0),
              borderRadius: BorderRadius.circular(8),
            ))),
        onPressed: () async {
          try {
            String? serverURL = dotenv.env['USER_SERVER_URL'];
            String URL = '${serverURL}/playlist/delete';
            final response = await http.delete(
              Uri.parse(URL),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({
                "postId": widget.post.postId,
              }),
            );
          } on SocketException {
            // 에러처리 (인터넷 연결 등등)
            EasyLoading.showToast("인터넷 연결을 확인해주세요");
          }
          for (int i = 0; i < 3; i++) Navigator.of(context).pop();
        },
        child: Text("삭제", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );

    AlertDialog alert = AlertDialog(
      content: IntrinsicHeight(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            "삭제하시겠습니까?",
            style: TextStyle(
                color: kPrimaryWhiteColor, fontSize: defaultSize * 1.4),
          )
        ]),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        cancelButton,
        blockButton,
      ],
      backgroundColor: kDialogColor,
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(child: alert);
        });
  }
}
