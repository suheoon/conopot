import 'dart:async';

import 'package:conopot/firebase/analytics_config.dart';
import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/models/music_state.dart';
import 'package:conopot/models/note.dart';
import 'package:conopot/models/note_state.dart';
import 'package:conopot/models/pitch_item.dart';
import 'package:conopot/models/youtube_player_state.dart';
import 'package:conopot/screens/note/note_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class NoteList extends StatefulWidget {
  NoteList({Key? key}) : super(key: key);

  @override
  State<NoteList> createState() => _NoteListState();
}

// 애창곡 노트뷰 노트 리스트
class _NoteListState extends State<NoteList> {
  double defaultSize = SizeConfig.defaultSize;

  // 애창곡 노트 설정에 따라 달라지는 정보 (최고음 or TJ 노래번호)
  Widget _userSettingInfo(int setNum, Note note, int userPitch) {
    if (setNum == 0) {
      return Center(
        child: Text(
          '${note.tj_songNumber}',
          style: TextStyle(
            color: kMainColor,
            fontSize: defaultSize * 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else if (setNum == 1) {
      if (note.pitchNum != 0) {
        return Center(
          child: Text(
            pitchNumToString[note.pitchNum],
            style: TextStyle(
              color: kMainColor,
              fontSize: defaultSize * 0.9,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    }
    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    double screenHieght = SizeConfig.screenHeight;

    return Expanded(
      child: Consumer<NoteState>(
        builder: (context, noteData, child) {
          return Theme(
            data: ThemeData(
              canvasColor: Colors.transparent,
            ),
            child: ReorderableListView(
              buildDefaultDragHandles: true,
              padding: EdgeInsets.only(bottom: screenHieght * 0.3),
              children: noteData.notes.map(
                (note) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(
                        defaultSize, 0, defaultSize * 0.5, defaultSize * 0.5),
                    key: Key(
                      '${noteData.notes.indexOf(note)}',
                    ),
                    child: Slidable(
                        endActionPane: ActionPane(
                            extentRatio: .18,
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (value) {
                                  Provider.of<NoteState>(context, listen: false)
                                      .showDeleteDialog(context, note);
                                },
                                backgroundColor: kPrimaryLightBlackColor,
                                foregroundColor: kMainColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                icon: Icons.delete_outlined,
                              ),
                            ]),
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<YoutubePlayerState>(context,
                                    listen: false)
                                .openPlayer();
                            Provider.of<YoutubePlayerState>(context,
                                    listen: false)
                                .refresh();
                            Provider.of<YoutubePlayerState>(context,
                                    listen: false)
                                .enterNoteDetailScreen(
                                    noteData.notes.indexOf(note));
                            Provider.of<YoutubePlayerState>(context,
                                    listen: false)
                                .changePlayingIndex(
                                    noteData.notes.indexOf(note));
                            Analytics_config().viewNoteEvent(note);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NoteDetailScreen(note: note),
                              ),
                            );
                          },
                          child: Container(
                            height: note.memo.isEmpty
                                ? defaultSize * 7
                                : defaultSize * 8,
                            key: Key(
                              '${noteData.notes.indexOf(note)}',
                            ),
                            margin:
                                EdgeInsets.fromLTRB(0, 0, defaultSize * 0.5, 0),
                            padding: EdgeInsets.only(right: defaultSize),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: kPrimaryLightBlackColor.withOpacity(0.9),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: defaultSize),
                                  child: SizedBox(
                                      width: defaultSize * 5,
                                      child: Center(
                                        child: _userSettingInfo(
                                            Provider.of<NoteState>(
                                                    context,
                                                    listen: true)
                                                .userNoteSetting,
                                            note,
                                            Provider.of<MusicState>(
                                                    context,
                                                    listen: true)
                                                .userMaxPitch),
                                      )),
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${note.tj_title}',
                                      style: TextStyle(
                                        color: kPrimaryWhiteColor,
                                        fontSize: defaultSize * 1.4,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (note.memo.isEmpty) ...[
                                      SizedBox(height: defaultSize * 0.3)
                                    ],
                                    Text(
                                      '${note.tj_singer}',
                                      style: TextStyle(
                                        color: kPrimaryLightWhiteColor,
                                        fontSize: defaultSize * 1.2,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (note.memo.isNotEmpty) ...[
                                      SizedBox(height: defaultSize * 0.3),
                                      Container(
                                        margin:
                                            EdgeInsets.only(right: defaultSize),
                                        padding:
                                            EdgeInsets.all(defaultSize * 0.5),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: kPrimaryGreyColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            note.memo,
                                            style: TextStyle(
                                                color: kPrimaryLightWhiteColor,
                                                fontSize: defaultSize * 1.2,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    ]
                                  ],
                                )),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.chevron_right,
                                        color: kPrimaryWhiteColor),
                                    Text("상세정보",
                                        style: TextStyle(
                                            color: kPrimaryWhiteColor,
                                            fontSize: defaultSize))
                                  ],
                                )
                              ],
                            ),
                          ),
                        )),
                  );
                },
              ).toList(),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final Note note = noteData.notes.removeAt(oldIndex);
                  noteData.notes.insert(newIndex, note);
                  Provider.of<YoutubePlayerState>(context, listen: false)
                      .reorder(oldIndex, newIndex);
                  Provider.of<YoutubePlayerState>(context, listen: false)
                      .closePlayer();
                  Provider.of<YoutubePlayerState>(context, listen: false)
                      .refresh();
                  Timer(Duration(microseconds: 500), () {
                    Provider.of<YoutubePlayerState>(context, listen: false)
                        .openPlayer();
                    Provider.of<YoutubePlayerState>(context, listen: false)
                        .refresh();
                  });
                  Provider.of<NoteState>(context, listen: false).reorderEvent();
                });
              },
            ),
          );
        },
      ),
    );
  }
}
