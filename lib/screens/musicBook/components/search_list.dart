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
                  title: Text(musicList.foundItems[index].title),
                  subtitle: Text(musicList.foundItems[index].singer),
                  trailing: Text(musicList.foundItems[index].songNumber),
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
