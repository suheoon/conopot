import 'dart:convert';
import 'dart:io';
import 'package:conopot/config/constants.dart';
import 'package:conopot/config/size_config.dart';
import 'package:conopot/debounce.dart';
import 'package:conopot/models/music_search_item_list.dart';
import 'package:conopot/models/note_data.dart';
import 'package:conopot/models/post.dart';
import 'package:conopot/screens/feed/components/search_song_list.dart';
import 'package:conopot/screens/feed/components/added_song_list.dart';
import 'package:flutter/material.dart';
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
  var _emotionList = ["😀", "🥲", "😡", "😳", "🫠"];
  bool _iseditting = false;
  String _listName = "";
  String _explanation = "";
  final Debounce _debounce = Debounce(delay: Duration(milliseconds: 500));
  late TextEditingController listTitleController;
  late TextEditingController listSubscriptionController;

  @override
  void initState() {
    _emotionIndex = widget.post.postIconId;
    _listName = widget.post.postTitle;
    _explanation = widget.post.postSubscription;
    listTitleController = TextEditingController(text: "${widget.post.postTitle}");
    listSubscriptionController = TextEditingController(text: "${widget.post.postSubscription}");
    super.initState();
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      appBar: AppBar(
        title: Text("리스트 수정", style: TextStyle(color: kPrimaryWhiteColor)),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () async {
                if (_listName.isEmpty) {
                  EasyLoading.showError("리스트명을 입력해주세요");
                } else if (Provider.of<NoteData>(context, listen: false)
                        .lists
                        .length <
                    3) {
                  EasyLoading.showError("노래를 3개이상 추가해 주세요");
                } else {
                  List<String> songList =
                      Provider.of<NoteData>(context, listen: false)
                          .lists
                          .map((e) => e.tj_songNumber)
                          .toList();
                  try {
                    String URL = "http://10.0.2.2:3000/playlist/update";
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
                            Provider.of<NoteData>(context, listen: false)
                                .userId,
                        "postMusicList": jsonEncode(songList)
                      }),
                    );
                    for (int i = 0; i < 3; i++) Navigator.of(context).pop();
                  } on HttpException {
                    // 인터넷 연결 예외처리
                    EasyLoading.showError("인터넷 연결을 확인해주세요");
                  } catch (e) {
                    print(e);
                  }
                }
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(defaultSize, defaultSize * 0.5,
                      defaultSize, defaultSize * 0.5),
                  decoration: BoxDecoration(
                      color: kMainColor.withOpacity(0.8),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child:
                      Text("수정", style: TextStyle(color: kPrimaryWhiteColor))))
        ],
      ),
      body: Consumer<MusicSearchItemLists>(
        builder: (
          context,
          musicList,
          child,
        ) =>
            Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultSize),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text("느낌 아이콘",
                        style: TextStyle(color: kPrimaryLightWhiteColor)),
                    SizedBox(height: defaultSize),
                    Text(
                      "${_emotionList[_emotionIndex]}",
                      style: TextStyle(fontSize: defaultSize * 4),
                    ),
                    SizedBox(height: defaultSize * 1.25),
                    (_iseditting == false)
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _iseditting = true;
                              });
                            },
                            child: Text("변경하기",
                                style: TextStyle(color: kMainColor)))
                        : Container(
                            child: IntrinsicWidth(
                                child: Row(
                                    children: _emotionList
                                        .map((e) => Container(
                                              margin: EdgeInsets.only(
                                                  left: defaultSize),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _emotionIndex =
                                                        _emotionList.indexOf(e);
                                                    _iseditting = false;
                                                  });
                                                },
                                                child: Text(e,
                                                    style: TextStyle(
                                                        fontSize:
                                                            defaultSize * 2)),
                                              ),
                                            ))
                                        .toList())),
                          ),
                  ],
                ),
              ],
            ),
            Text("리스트명 (필수)", style: TextStyle(color: kPrimaryWhiteColor)),
            SizedBox(height: defaultSize * 0.5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: defaultSize),
              decoration: BoxDecoration(
                color: kPrimaryLightBlackColor,
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: TextField(
                controller: listTitleController,
                style: TextStyle(color: kPrimaryWhiteColor),
                onChanged: (text) => {
                  setState(() {
                    _listName = text;
                  })
                },
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.text,
                cursorColor: kMainColor,
                decoration: InputDecoration(
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
            Text("추가설명 (선택)", style: TextStyle(color: kPrimaryWhiteColor)),
            SizedBox(height: defaultSize * 0.5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: defaultSize),
              decoration: BoxDecoration(
                color: kPrimaryLightBlackColor,
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: TextField(
                style: TextStyle(color: kPrimaryWhiteColor),
                onChanged: (text) => {
                  setState(() {
                    _explanation = text;
                  })
                },
                controller: listSubscriptionController,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                cursorColor: kMainColor,
                decoration: InputDecoration(
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
            SizedBox(height: defaultSize * 2),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                addSongDialog(context, musicList);
              },
              child: Row(
                children: [
                  Text("애창곡 추가",
                      style: TextStyle(color: kPrimaryLightWhiteColor)),
                  Spacer(),
                  Icon(Icons.chevron_right, color: kPrimaryWhiteColor)
                ],
              ),
            ),
            AddedSongListView()
          ]),
        ),
      ),
    );
  }

  // 노래 추가 다이어로그 팝업 함수
  void addSongDialog(
      BuildContext context, MusicSearchItemLists musicList) async {
    double defaultSize = SizeConfig.defaultSize;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Center(
              child: Container(
                width: SizeConfig.screenWidth * 0.8,
                height: SizeConfig.screenHeight * 0.75,
                color: kDialogColor,
                child: Column(
                  children: [
                    SizedBox(height: defaultSize),
                    // 검색 창
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          defaultSize, 0, defaultSize, defaultSize),
                      decoration: BoxDecoration(
                          color: kPrimaryLightBlackColor,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          border: Border.all(
                              width: 0.5, color: kPrimaryWhiteColor)),
                      child: TextField(
                        style: TextStyle(color: kPrimaryWhiteColor),
                        onChanged: (text) => {
                          _debounce.call(() {
                            musicList.runCombinedFilter(text);
                            setState(() {});
                          })
                        },
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.name,
                        cursorColor: kMainColor,
                        decoration: InputDecoration(
                          hintText: '노래, 가수 검색',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: defaultSize * 1.5,
                            color: kPrimaryLightGreyColor,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: kPrimaryWhiteColor,
                          ),
                        ),
                      ),
                    ),
                    SearchSongList(
                      musicList: musicList,
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}
