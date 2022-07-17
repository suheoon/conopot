import 'package:conopot/config/analytics_config.dart';
import 'package:conopot/config/constants.dart';
import 'package:conopot/models/music_search_item.dart';
import 'package:conopot/models/music_search_item_lists.dart';
import 'package:conopot/models/note_data.dart';
import 'package:conopot/models/pitch_item.dart';
import 'package:conopot/config/size_config.dart';
import 'package:conopot/models/pitch_music.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class PitchSearchList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MusicSearchItemLists>(
      builder: (
        context,
        musicList,
        child,
      ) =>
          Expanded(
        child: musicList.highestFoundItems.isNotEmpty
            ? ListView.builder(
                itemCount: musicList.highestFoundItems.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.white,
                  elevation: 1,
                  child: ListTile(
                      leading: Container(
                        width: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              pitchNumToString[
                                  musicList.highestFoundItems[index].pitchNum],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      title: Text(
                        musicList.highestFoundItems[index].tj_title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kTitleColor,
                        ),
                      ),
                      subtitle: Text(
                        musicList.highestFoundItems[index].tj_singer,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kSubTitleColor,
                        ),
                      ),
                      onTap: () {
                        // !event : 음역대 측정 결과 뷰 - 내 최고음 주변의 인기곡들
                        Analytics_config.analytics
                            .logEvent('음역대 측정 결과 뷰 - 내 최고음 주변의 인기곡들');
                        if (musicList.tabIndex == 1) {
                          _showAddDialog(context,
                              musicList.highestFoundItems[index]);
                        }
                      }),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(),
              ),
      ),
    );
  }
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
