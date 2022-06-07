import 'package:conopot/models/music_search_item_lists.dart';
import 'package:flutter/material.dart';

class SearchList extends StatelessWidget {
  final MusicSearchItemLists musicList;

  const SearchList({super.key, required this.musicList});

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
                  contentPadding: EdgeInsets.only(
                    left: 15.0,
                  ),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        musicList.foundItems[index].songNumber,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  title: Text(musicList.foundItems[index].title),
                  subtitle: Text(musicList.foundItems[index].singer),
                ),
              ),
            )
          : Text(
              '검색 결과가 없습니다',
              style: TextStyle(fontSize: 18),
            ),
    );
  }
}
