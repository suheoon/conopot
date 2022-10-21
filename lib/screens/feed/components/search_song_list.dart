import 'package:conopot/config/constants.dart';
import 'package:conopot/config/size_config.dart';
import 'package:conopot/models/music_search_item_list.dart';
import 'package:conopot/models/note_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class SearchSongList extends StatefulWidget {
  final MusicSearchItemLists musicList;
  const SearchSongList({super.key, required this.musicList});

  @override
  State<SearchSongList> createState() => _SearchSongListState();
}

class _SearchSongListState extends State<SearchSongList> {
  double defaultSize = SizeConfig.defaultSize;
  Widget _ListView(BuildContext context) {
    return widget.musicList.combinedFoundItems.isNotEmpty
        ? Consumer<NoteData>(
            builder: (context, notedata, child) => Expanded(
              child: ListView.builder(
                  itemCount: widget.musicList.combinedFoundItems.length,
                  itemBuilder: (context, index) {
                      String songNumber = widget
                          .musicList
                          .combinedFoundItems[index]
                          .tj_songNumber;
                      String title = widget
                          .musicList
                          .combinedFoundItems[index]
                          .tj_title;
                      String singer = widget
                          .musicList
                          .combinedFoundItems[index]
                          .tj_singer;
                      int pitchNum = widget
                          .musicList
                          .combinedFoundItems[index]
                          .pitchNum;
                      return Container(
                        margin: EdgeInsets.fromLTRB(
                            defaultSize, 0, defaultSize, defaultSize * 0.5),
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<NoteData>(context, listen: false)
                                .showAddListSongDialog(context, songNumber, title);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    ],
                                  ),
                                ),
                                SizedBox(width: defaultSize * 1.5),
                                SizedBox(
                                    width: defaultSize * 2.1,
                                    height: defaultSize * 1.9,
                                    child: SvgPicture.asset(
                                        "assets/icons/listButton.svg", color: kPrimaryWhiteColor,)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
            ),
          ))
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
}
