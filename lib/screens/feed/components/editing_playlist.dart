import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/models/note.dart';
import 'package:conopot/models/note_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditingPlayList extends StatefulWidget {
  EditingPlayList({Key? key}) : super(key: key);

  @override
  State<EditingPlayList> createState() => _EditingPlayListState();
}

// 플레이리스트 생성 플레이리스 편집 리스트뷰
class _EditingPlayListState extends State<EditingPlayList> {
  double defaultSize = SizeConfig.defaultSize;

  @override
  Widget build(BuildContext context) {
    double screenHieght = SizeConfig.screenHeight;

    return Consumer<NoteState>(
      builder: (context, noteData, child) {
        return Theme(
          data: ThemeData(
            canvasColor: Colors.transparent,
          ),
          child: ReorderableListView(
            padding: EdgeInsets.only(bottom: screenHieght * 0.3),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: true,
            children: noteData.lists.map(
              (list) {
                return Container(
                  margin: EdgeInsets.fromLTRB(
                      0, 0, 0, defaultSize * 0.5),
                  key: Key(
                    '${noteData.lists.indexOf(list)}',
                  ),
                  child: Container(
                    height: list.memo.isEmpty
                        ? defaultSize * 7 * SizeConfig.textScaleFactor
                        : defaultSize * 8,
                    key: Key(
                      '${noteData.lists.indexOf(list)}',
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: kPrimaryLightBlackColor,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: defaultSize),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${list.tj_title}',
                                style: TextStyle(
                                  color: kPrimaryWhiteColor,
                                  fontSize: defaultSize * 1.4,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (list.memo.isEmpty) ...[
                                SizedBox(height: defaultSize * 0.3)
                              ],
                              Text(
                                '${list.tj_singer}',
                                style: TextStyle(
                                  color: kPrimaryLightWhiteColor,
                                  fontSize: defaultSize * 1.2,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (list.memo.isNotEmpty) ...[
                                SizedBox(height: defaultSize * 0.3),
                                Container(
                                  padding: EdgeInsets.all(defaultSize * 0.5),
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
                                      list.memo,
                                      style: TextStyle(
                                          color: kPrimaryLightWhiteColor,
                                          fontSize: defaultSize * 1.2,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                )
                              ]
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: defaultSize),
                          child: ReorderableDragStartListener(
                              index: noteData.lists.indexOf(list),
                              child: Icon(
                                Icons.drag_handle,
                                color: kPrimaryLightGreyColor,
                              )),
                        ),
                        GestureDetector(
                            onTap: () {
                              noteData.deleteList(list);
                              setState(() {});
                            },
                            child: Text("삭제",
                                style: TextStyle(
                                    color: kPrimaryLightGreyColor))),
                        SizedBox(width: defaultSize)
                      ],
                    ),
                  ),
                );
              },
            ).toList(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final Note note = noteData.lists.removeAt(oldIndex);
                noteData.lists.insert(newIndex, note);
              });
            },
          ),
        );
      },
    );
  }
}
