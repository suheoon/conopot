import 'package:conopot/config/constants.dart';
import 'package:conopot/models/music_search_item_lists.dart';
import 'package:conopot/models/note_data.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SearchList extends StatelessWidget {
  final MusicSearchItemLists musicList;
  final int tabIdx;

  const SearchList({super.key, required this.musicList, required this.tabIdx});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: musicList.foundItems.isNotEmpty
          ? ListView.builder(
              itemCount: musicList.foundItems.length,
              itemBuilder: (context, index) => Card(
                color: Colors.white,
                elevation: 1,
                child: ListTile(
                    title: Text(
                      musicList.foundItems[index].title,
                      style: TextStyle(
                          color: kTitleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    subtitle: Text(musicList.foundItems[index].singer,
                        style: TextStyle(
                          color: kSubTitleColor,
                          fontWeight: FontWeight.bold,
                        )),
                    trailing: Text(musicList.foundItems[index].songNumber),
                    onTap: () {
                      if (musicList.tabIndex == 1) {
                        _showDeleteDialog(
                            context, musicList.foundItems[index].songNumber);
                      }
                    }),
              ),
            )
          : Text(
              '검색 결과가 없습니다',
              style: TextStyle(fontSize: 18),
            ),
    );
  }
}

_showDeleteDialog(BuildContext context, String songNumber) {
  Widget okButton = ElevatedButton(
    onPressed: () {
      Provider.of<NoteData>(context, listen: false).addNodeBySongNumber(
          songNumber,
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
      "노트를 추가하시겠습니까?",
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
