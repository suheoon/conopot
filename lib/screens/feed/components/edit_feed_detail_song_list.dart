import 'package:conopot/config/constants.dart';
import 'package:conopot/config/size_config.dart';
import 'package:conopot/models/note.dart';
import 'package:conopot/models/note_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditFeedDetailSongList extends StatefulWidget {
  List<Note> postList;
  Function checkedCountChange;
  EditFeedDetailSongList(
      {super.key, required this.postList, required this.checkedCountChange});

  @override
  State<EditFeedDetailSongList> createState() => _EditFeedDetailSongListState();
}

class _EditFeedDetailSongListState extends State<EditFeedDetailSongList> {
  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Consumer<NoteData>(builder: (context, noteData, child) {
      return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.3),
          itemCount: widget.postList.length,
          itemBuilder: (context, index) {
            String songNumber = widget.postList[index].tj_songNumber;
            String title = widget.postList[index].tj_title;
            String singer = widget.postList[index].tj_singer;
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (!noteData.feedDetailCheckList[index] == true) {
                    Provider.of<NoteData>(context, listen: false)
                        .addSet
                        .add(widget.postList[index]);
                  } else {
                    Provider.of<NoteData>(context, listen: false)
                        .addSet
                        .remove(widget.postList[index]);
                  }
                  widget.checkedCountChange(
                      !noteData.feedDetailCheckList[index]);
                  noteData.feedDetailCheckList[index] =
                      !noteData.feedDetailCheckList[index];
                });
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(
                    defaultSize, 0, defaultSize, defaultSize * 0.5),
                child: Container(
                  width: defaultSize * 35.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: kPrimaryLightBlackColor),
                  padding: EdgeInsets.all(defaultSize * 1.5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                          checkColor: kMainColor,
                          activeColor: Colors.transparent,
                          side: BorderSide(color: kPrimaryLightGreyColor),
                          shape: CircleBorder(),
                          value: noteData.feedDetailCheckList[index],
                          onChanged: (bool? val) {
                            if (val == true) {
                              Provider.of<NoteData>(context, listen: false)
                                  .addSet
                                  .add(widget.postList[index]);
                            } else {
                              Provider.of<NoteData>(context, listen: false)
                                  .addSet
                                  .remove(widget.postList[index]);
                            }
                            setState(() {
                              widget.checkedCountChange(val!);
                              noteData.feedDetailCheckList[index] = val;
                            });
                          }),
                      SizedBox(width: defaultSize),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: defaultSize * 1.4,
                                fontWeight: FontWeight.w600,
                                color: kPrimaryWhiteColor,
                              ),
                            ),
                            SizedBox(
                              height: defaultSize * 0.2,
                            ),
                            Text(
                              singer,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: defaultSize * 1.2,
                                fontWeight: FontWeight.w500,
                                color: kPrimaryLightWhiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }
}
