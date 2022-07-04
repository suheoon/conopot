import 'package:conopot/config/size_config.dart';
import 'package:conopot/models/music_search_item_lists.dart';
import 'package:conopot/models/note_data.dart';
import 'package:conopot/models/pitch_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteSearchList extends StatefulWidget {
  final MusicSearchItemLists musicList;

  const NoteSearchList({super.key, required this.musicList});

  @override
  State<NoteSearchList> createState() => _NoteSearchListState();
}

class _NoteSearchListState extends State<NoteSearchList> {
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
                                    maxLines: 1),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.musicList.combinedFoundItems[index]
                                      .tj_singer,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
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
                                            Radius.circular(10)),
                                        child: Container(
                                          decoration:
                                              BoxDecoration(color: Colors.red),
                                          padding: EdgeInsets.all(3),
                                          child: Text("최고음"),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(pitchNumToString[widget.musicList
                                          .combinedFoundItems[index].pitchNum]),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(widget.musicList
                                .combinedFoundItems[index].tj_songNumber),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => setState(() {
                      Provider.of<NoteData>(context, listen: false)
                          .setSelectedIndex(index);
                      Provider.of<NoteData>(context, listen: false)
                          .showTextFiled();
                      Provider.of<NoteData>(context, listen: false)
                              .musicSearchItem =
                          widget.musicList.combinedFoundItems[index];
                    }),
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

  @override
  Widget build(BuildContext context) {
    return _ListView(context);
  }
}
