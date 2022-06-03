import 'package:conopot/models/MusicSearchItemLists.dart';
import 'package:conopot/size_config.dart';
import 'package:flutter/material.dart';

class FitchSearchList extends StatelessWidget {
  final MusicSearchItemLists musicList;

  const FitchSearchList({super.key, required this.musicList});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: musicList.highestFoundItems.isNotEmpty
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
                      (musicList.userFitch - 2 >
                              musicList.highestFoundItems[index].fitchNum)
                          ? '쉬움'
                          : (musicList.userFitch + 2 >
                                  musicList.highestFoundItems[index].fitchNum)
                              ? '적정'
                              : '어려움',
                      style: TextStyle(color: Colors.green),
                    )),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '검색 결과가 없습니다',
                  style: TextStyle(fontSize: 21),
                ),
                SizedBox(
                  height: SizeConfig.defaultSize,
                ),
                Text('옥타브가 궁금한 노래는 아래 메일로 문의주세요!'),
                Text('soo7652@naver.com'),
              ],
            ),
    );
  }
}
