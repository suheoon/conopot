import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/models/music_state.dart';
import 'package:conopot/models/note_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class NoteSearchList extends StatefulWidget {
  final MusicState musicList;
  const NoteSearchList({super.key, required this.musicList});

  @override
  State<NoteSearchList> createState() => _NoteSearchListState();
}

class _NoteSearchListState extends State<NoteSearchList> {
  double defaultSize = SizeConfig.defaultSize;

  @override
  void initState() {
    super.initState();
  }

  Widget _ListView(BuildContext context) {
    return widget.musicList.foundItems.isNotEmpty
        ? Consumer<NoteState>(
            builder: (context, notedata, child) => Expanded(
              child: ListView.builder(
                  itemCount: widget.musicList.foundItems.length,
                  itemBuilder: (context, index) {
                    String songNumber =
                        widget.musicList.foundItems[(index)].songNumber;
                    String title = widget.musicList.foundItems[(index)].title;
                    String singer = widget.musicList.foundItems[(index)].singer;
                    return Container(
                      margin: EdgeInsets.fromLTRB(
                          defaultSize, 0, defaultSize, defaultSize * 0.5),
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<NoteState>(context, listen: false)
                              .showAddNoteDialog(context, songNumber, title);
                        },
                        child: Container(
                          width: defaultSize * 35.5,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: kPrimaryLightBlackColor),
                          padding: EdgeInsets.all(defaultSize * 1.5),
                          child: Row(
                            children: [
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
                                    SizedBox(
                                      height: defaultSize * 0.5,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: defaultSize * 4.5,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${songNumber}',
                                              style: TextStyle(
                                                color: kMainColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: defaultSize * 1.2,
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (widget
                                                .musicList
                                                .combinedFoundItems[(index)]
                                                .pitchNum !=
                                            0) ...[
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width: defaultSize * 0.3),
                                            ],
                                          )
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: defaultSize * 1.5),
                              SizedBox(
                                  width: defaultSize * 2.1,
                                  height: defaultSize * 1.9,
                                  child: SvgPicture.asset(
                                      "assets/icons/listButton.svg")),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          )
        : Expanded(
            child: Center(
              child: Text(
                '검색 결과가 없습니다',
                style: TextStyle(
                  fontSize: defaultSize * 1.8,
                  fontWeight: FontWeight.w300,
                  color: kPrimaryWhiteColor,
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return _ListView(context);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
