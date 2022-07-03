import 'package:conopot/config/size_config.dart';
import 'package:conopot/models/music_search_item_lists.dart';
import 'package:conopot/models/note_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteSearchList extends StatefulWidget {
  final MusicSearchItemLists musicList;

  const NoteSearchList({super.key, required this.musicList});

  @override
  State<NoteSearchList> createState() => _NoteSearchListState();
}

class _NoteSearchListState extends State<NoteSearchList> {
  int _selectedIndex = -1;

  Widget _ListView(BuildContext context) {
    return widget.musicList.foundItems.isNotEmpty
          ? Expanded(
            child: ListView.builder(
                itemCount: widget.musicList.foundItems.length,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 100,
                  child: Card(
                    elevation: 0,
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedIndex == index ? Colors.grey[300] : null,
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
                                  Text(widget.musicList.foundItems[index].title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.musicList.foundItems[index].singer,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10)),
                                        child: Container(
                                          decoration:
                                              BoxDecoration(color: Colors.red),
                                          padding: EdgeInsets.all(3),
                                          child: Text("최고음"),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text("3옥타브 라")
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  widget.musicList.foundItems[index].songNumber),
                            ),
                          ],
                        ),
                      ),
                      onTap: () => setState(() {
                        _selectedIndex = index;
                        Provider.of<NoteData>(context, listen: false).showTextFiled();
                        Provider.of<NoteData>(context, listen: false).musicSearchItem = widget.musicList.foundItems[index];
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
