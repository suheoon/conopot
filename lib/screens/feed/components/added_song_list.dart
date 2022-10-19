import 'package:conopot/config/constants.dart';
import 'package:conopot/config/size_config.dart';
import 'package:conopot/models/note.dart';
import 'package:conopot/models/note_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class AddedSongListView extends StatefulWidget {
  AddedSongListView({Key? key}) : super(key: key);

  @override
  State<AddedSongListView> createState() => _AddedSongListViewState();
}

// 피드 생성시 추가한 노래 리스트
class _AddedSongListViewState extends State<AddedSongListView> {
  double defaultSize = SizeConfig.defaultSize;

  @override
  Widget build(BuildContext context) {
    double screenHieght = SizeConfig.screenHeight;

    return Expanded(
      child: Consumer<NoteData>(
        builder: (context, noteData, child) {
          return Theme(
            data: ThemeData(
              canvasColor: Colors.transparent,
            ),
            child: ReorderableListView(
              buildDefaultDragHandles: true,
              padding: EdgeInsets.only(bottom: screenHieght * 0.3),
              children: noteData.lists.map(
                (list) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(
                        defaultSize * 0.5, 0, 0, defaultSize * 0.5),
                    key: Key(
                      '${noteData.lists.indexOf(list)}',
                    ),
                    child: Slidable(
                        endActionPane: ActionPane(
                            extentRatio: .18,
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (value) {
                                  Provider.of<NoteData>(context, listen: false)
                                      .showDeleteDialog(context, list);
                                },
                                backgroundColor: kPrimaryLightBlackColor,
                                foregroundColor: kMainColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                icon: Icons.delete_outlined,
                              ),
                            ]),
                        child: Container(
                          height: list.memo.isEmpty
                              ? defaultSize * 7 * SizeConfig.textScaleFactor
                              : defaultSize * 8,
                          key: Key(
                            '${noteData.lists.indexOf(list)}',
                          ),
                          margin:
                              EdgeInsets.fromLTRB(0, 0, defaultSize * 0.5, 0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                            color: kPrimaryLightBlackColor,
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: defaultSize),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
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
                                            list.memo,
                                            style: TextStyle(
                                                color:
                                                    kPrimaryLightWhiteColor,
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: defaultSize),
                                child: ReorderableDragStartListener(
                                    index: noteData.lists.indexOf(list),
                                    child: Icon(
                                      Icons.drag_handle,
                                      color: kPrimaryLightGreyColor,
                                    )),
                              ),
                            ],
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
                  final Note note = noteData.lists.removeAt(oldIndex);
                  noteData.lists.insert(newIndex, note);
                  Provider.of<NoteData>(context, listen: false).reorderEvent();
                });
              },
            ),
          );
        },
      ),
    );
  }
}
