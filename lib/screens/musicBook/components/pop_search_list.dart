import 'package:conopot/config/constants.dart';
import 'package:conopot/models/music_search_item_lists.dart';
import 'package:flutter/material.dart';

class PopSearchList extends StatelessWidget {
  final MusicSearchItemLists musicList;

  const PopSearchList({super.key, required this.musicList});

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
                  leading: Container(
                    width: 35,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (index == 0)
                            ? Image(
                                image: AssetImage('assets/images/first.png'),
                                width: 30,
                                height: 30,
                              )
                            : (index == 1)
                                ? Image(
                                    image:
                                        AssetImage('assets/images/second.png'),
                                    width: 30,
                                    height: 30,
                                  )
                                : (index == 2)
                                    ? Image(
                                        image: AssetImage(
                                            'assets/images/third.png'),
                                        width: 30,
                                        height: 30,
                                      )
                                    : Row(
                                        children: [
                                          Text((index + 1).toString() + "위", style: TextStyle(fontWeight: FontWeight.bold, color: kTextColor),),
                                        ],
                                      ),
                      ],
                    ),
                  ),
                  title: Text(musicList.foundItems[index].title, style: TextStyle(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18),),
                  subtitle: Text(musicList.foundItems[index].singer, style: TextStyle(color: kSubTitleColor, fontWeight: FontWeight.bold)),
                  trailing: Text(musicList.foundItems[index].songNumber, style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryBlackColor),),
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
