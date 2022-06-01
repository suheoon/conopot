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
              itemCount: musicList.foundItems.length,
              itemBuilder: (context, index) => Card(
                color: Colors.white,
                elevation: 1,
                child: ListTile(
                    leading: Text(
                      musicList.foundItems[index].songNumber,
                    ),
                    title: Text(musicList.foundItems[index].title),
                    subtitle: Text(musicList.foundItems[index].singer),
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
