import 'package:conopot/config/analytics_config.dart';
import 'package:conopot/config/size_config.dart';
import 'package:conopot/models/music_search_item_lists.dart';
import 'package:conopot/models/note_data.dart';
import 'package:conopot/models/pitch_item.dart';
import 'package:conopot/models/pitch_music.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../config/constants.dart';

class NoteSearchList extends StatefulWidget {
  final MusicSearchItemLists musicList;

  const NoteSearchList({super.key, required this.musicList});

  @override
  State<NoteSearchList> createState() => _NoteSearchListState();
}

class _NoteSearchListState extends State<NoteSearchList> {
  TextEditingController memoController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _ListView(context);
  }

  Widget _ListView(BuildContext context) {
    int _selectedIndex =
        Provider.of<NoteData>(context, listen: false).selectedIndex;
    return widget.musicList.combinedFoundItems.isNotEmpty
        ? Expanded(
            child: ListView.builder(
              itemCount: widget.musicList.combinedFoundItems.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                height: 100,
                child: Card(
                  elevation: 0,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      Provider.of<NoteData>(context, listen: false)
                          .setSelectedIndex(index);
                      Provider.of<NoteData>(context, listen: false)
                              .clickedItem =
                          widget.musicList.combinedFoundItems[index];
                      //!event: 곡 추가 뷰 - 리스트 클릭 시
                      Provider.of<NoteData>(context, listen: false)
                          .addSongClickEvent(
                              widget.musicList.combinedFoundItems[index]);
                      _showAddDialog(context, widget.musicList.combinedFoundItems[index]);
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            _selectedIndex == index ? Colors.grey[300] : null,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      height: 70,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.musicList.combinedFoundItems[index]
                                      .tj_title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: kTitleColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.musicList.combinedFoundItems[index]
                                      .tj_singer,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: kSubTitleColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                if (widget.musicList.combinedFoundItems[index]
                                        .pitch !=
                                    '?')
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: kPrimaryColor),
                                          padding: EdgeInsets.all(3),
                                          child: Text(
                                            "최고음",
                                            style: TextStyle(
                                              color: kPrimaryCreamColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        pitchNumToString[widget
                                            .musicList
                                            .combinedFoundItems[index]
                                            .pitchNum],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              widget.musicList.combinedFoundItems[index]
                                  .tj_songNumber,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Text(
            '검색 결과가 없습니다',
            style: TextStyle(fontSize: 18),
          );
  }

  _showAddDialog(BuildContext context, FitchMusic item) {
  Widget okButton = ElevatedButton(
    onPressed: () {
      Provider.of<NoteData>(context, listen: false).addNoteBySongNumber(
          item.tj_songNumber,
          Provider.of<MusicSearchItemLists>(context, listen: false)
              .combinedSongList);
      Navigator.of(context).pop();
      if (Provider.of<NoteData>(context, listen: false).emptyCheck == true) {
        Fluttertoast.showToast(
            msg: "이미 저장된 노래입니다😅",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Provider.of<NoteData>(context, listen: false).initEmptyCheck();
      } else {
        Fluttertoast.showToast(
            msg: "노트가 생성되었습니다😆",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: kPrimaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    },
    child: Text("추가", style: TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.red),
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text("취소", style: TextStyle(fontWeight: FontWeight.bold)));

  AlertDialog alert = AlertDialog(
    content: Text(
      "${item.tj_title} 노래를 추가하시겠습니까?",
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    actions: [
      cancelButton,
      okButton,
    ],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(child: alert);
      });
}
}
