import 'dart:convert';
import 'dart:io';

import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/global/debounce.dart';
import 'package:conopot/models/note_state.dart';
import 'package:conopot/models/post.dart';
import 'package:conopot/screens/feed/components/added_playlist.dart';
import 'package:conopot/screens/feed/components/editing_playlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class UserFeedEditScreen extends StatefulWidget {
  Post post;
  UserFeedEditScreen({super.key, required this.post});

  @override
  State<UserFeedEditScreen> createState() => _UserFeedEditScreenState();
}

class _UserFeedEditScreenState extends State<UserFeedEditScreen> {
  int _emotionIndex = 0; // 😀, 🥲, 😡, 😳, 🫠
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
  bool _isIconEditting = false;
  bool _isListEditting = false;
  String _listName = "";
  String _explanation = "";
  late TextEditingController _titleController;
  late TextEditingController _subscriptionController;

  @override
  void initState() {
    _emotionIndex = widget.post.postIconId;
    _listName = widget.post.postTitle;
    _explanation = widget.post.postSubscription;
    _titleController = TextEditingController(text: "${widget.post.postTitle}");
    _subscriptionController =
        TextEditingController(text: "${widget.post.postSubscription}");
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subscriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      appBar: AppBar(
        title: Text("플레이리스트 수정", style: TextStyle(color: kPrimaryWhiteColor)),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () async {
                if (_listName.isEmpty) {
                  EasyLoading.showToast("리스트명을 입력해주세요");
                } else if (Provider.of<NoteState>(context, listen: false)
                        .lists
                        .length <
                    3) {
                  EasyLoading.showToast("노래를 세곡 이상 추가해주세요");
                } else {
                  List<String> songList =
                      Provider.of<NoteState>(context, listen: false)
                          .lists
                          .map((e) => e.tj_songNumber)
                          .toList();
                  try {
                    String? serverURL = dotenv.env['USER_SERVER_URL'];
                    String URL = "${serverURL}/playlist/update";
                    final response = await http.post(
                      Uri.parse(URL),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode({
                        "postId": widget.post.postId,
                        "postTitle": _listName,
                        "postIconId": _emotionIndex,
                        "postSubscription": _explanation,
                        "postAuthorId":
                            Provider.of<NoteState>(context, listen: false)
                                .userId,
                        "postMusicList": jsonEncode(songList)
                      }),
                    );
                    for (int i = 0; i < 3; i++) Navigator.of(context).pop();
                    EasyLoading.showToast("수정이 완료되었습니다.");
                  } on SocketException {
                    // 인터넷 연결 예외처리
                    EasyLoading.showToast("인터넷 연결을 확인해주세요");
                  }
                }
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(defaultSize, defaultSize * 0.5,
                      defaultSize, defaultSize * 0.5),
                  decoration: BoxDecoration(
                      color: kMainColor.withOpacity(0.8),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Text("완료",
                      style: TextStyle(
                          color: kPrimaryWhiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: defaultSize * 1.2))))
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultSize),
          child: ListView(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: defaultSize * 14,
                  child: Column(
                    children: [
                      Text("감정 이모지",
                          style: TextStyle(
                              color: kPrimaryLightWhiteColor,
                              fontSize: defaultSize * 1.6,
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: defaultSize),
                      Text(
                        "${_emotionList[_emotionIndex]}",
                        style: TextStyle(fontSize: defaultSize * 4),
                      ),
                      SizedBox(height: defaultSize * 1.25),
                      (_isIconEditting == false)
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isIconEditting = true;
                                });
                              },
                              child: Text("변경하기",
                                  style: TextStyle(
                                      color: kMainColor,
                                      fontSize: defaultSize * 1.3)))
                          : Container(
                              child: IntrinsicWidth(
                                  child: Column(
                                children: [
                                  Row(
                                      children: _emotionList
                                          .map((e) => Container(
                                                margin: EdgeInsets.only(
                                                    left: defaultSize),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _emotionIndex =
                                                          _emotionList
                                                              .indexOf(e);
                                                      _isIconEditting = false;
                                                    });
                                                  },
                                                  child: Text(e,
                                                      style: TextStyle(
                                                          fontSize:
                                                              defaultSize * 2)),
                                                ),
                                              ))
                                          .toList()),
                                  SizedBox(height: defaultSize * 0.5),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isIconEditting = false;
                                        });
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: kPrimaryWhiteColor,
                                        size: defaultSize * 1.8,
                                      ))
                                ],
                              )),
                            ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: defaultSize * 2),
            Text("리스트명 (필수)",
                style: TextStyle(
                    color: kPrimaryWhiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: defaultSize * 1.5)),
            SizedBox(height: defaultSize * 0.5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: defaultSize),
              decoration: BoxDecoration(
                color: kPrimaryLightBlackColor,
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: TextField(
                controller: _titleController,
                style: TextStyle(color: kPrimaryWhiteColor),
                onChanged: (text) => {
                  setState(() {
                    _listName = text;
                  })
                },
                maxLength: 50,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.text,
                cursorColor: kMainColor,
                decoration: InputDecoration(
                  counter: SizedBox.shrink(),
                  hintText: '리스트명을 입력해주세요',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: defaultSize * 1.5,
                    color: kPrimaryLightGreyColor,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: defaultSize * 2),
            Text("추가설명 (선택)",
                style: TextStyle(
                    color: kPrimaryWhiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: defaultSize * 1.5)),
            SizedBox(height: defaultSize * 0.5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: defaultSize),
              decoration: BoxDecoration(
                color: kPrimaryLightBlackColor,
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: TextField(
                controller: _subscriptionController,
                style: TextStyle(color: kPrimaryWhiteColor),
                onChanged: (text) => {
                  setState(() {
                    _explanation = text;
                  })
                },
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 200,
                cursorColor: kMainColor,
                decoration: InputDecoration(
                  counter: SizedBox.shrink(),
                  hintText: '추가설명을 입력해주세요',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: defaultSize * 1.5,
                    color: kPrimaryLightGreyColor,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: defaultSize * 5),
            Row(
              children: [
                Text("플레이리스트",
                    style: TextStyle(
                        color: kPrimaryLightWhiteColor,
                        fontSize: defaultSize * 1.5,
                        fontWeight: FontWeight.w500)),
                Spacer(),
                if (Provider.of<NoteState>(context, listen: true)
                        .lists
                        .isNotEmpty ||
                    _isListEditting == true)
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _isListEditting = !_isListEditting;
                        });
                      },
                      child: Text((_isListEditting) ? "완료" : "편집하기",
                          style: TextStyle(
                              color: kMainColor, fontWeight: FontWeight.w500)))
              ],
            ),
            SizedBox(height: defaultSize),
            (_isListEditting) ? EditingPlayList() : AddedPlaylist(),
          ]),
        ),
      ),
    );
  }
}
