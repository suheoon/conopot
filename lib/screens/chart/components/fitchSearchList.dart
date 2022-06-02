import 'package:conopot/models/MusicSearchItemLists.dart';
import 'package:flutter/material.dart';

class FitchSearchList extends StatelessWidget {
  final MusicSearchItemLists musicList;

  const FitchSearchList({super.key, required this.musicList});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: musicList.foundItems.isNotEmpty
          ? ListView.builder(
              itemCount: musicList.highestFoundItems.length,
              itemBuilder: (context, index) => Card(
                color: Colors.white,
                elevation: 1,
                child: ListTile(
                    leading: Text(
                      musicList.highestFoundItems[index].fitch,
                    ),
                    title: Text(musicList.highestFoundItems[index].tj_title),
                    subtitle:
                        Text(musicList.highestFoundItems[index].tj_singer),
                    trailing: Text(
                      '쉬움',
                      style: TextStyle(color: Colors.green),
                    )),
              ),
            )
          : Text(
              '검색 결과가 없습니다',
              style: TextStyle(fontSize: 18),
            ),
    );
  }
}
