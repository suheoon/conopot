import 'package:conopot/config/constants.dart';
import 'package:conopot/models/music_search_item_lists.dart';
import 'package:conopot/models/pitch_item.dart';
import 'package:conopot/config/size_config.dart';
import 'package:flutter/material.dart';

class PitchSearchList extends StatelessWidget {
  final MusicSearchItemLists musicList;

  const PitchSearchList({super.key, required this.musicList});

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
                  leading: Container(
                    width: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          pitchNumToString[
                              musicList.highestFoundItems[index].pitchNum],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    musicList.highestFoundItems[index].tj_title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kTitleColor,
                    ),
                  ),
                  subtitle: Text(
                    musicList.highestFoundItems[index].tj_singer,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kSubTitleColor,
                    ),
                  ),
                  // trailing: Text(
                  //   (musicList.userPitch - 2 >
                  //           musicList.highestFoundItems[index].pitchNum)
                  //       ? '쉬움'
                  //       : (musicList.userPitch + 2 >
                  //               musicList.highestFoundItems[index].pitchNum)
                  //           ? '적정'
                  //           : '어려움',
                  //   style: TextStyle(
                  //       color: (musicList.userPitch - 2 >
                  //               musicList.highestFoundItems[index].pitchNum)
                  //           ? Colors.green
                  //           : (musicList.userPitch + 2 >
                  //                   musicList
                  //                       .highestFoundItems[index].pitchNum)
                  //               ? Colors.blue
                  //               : Colors.red),
                  // )
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(),
            ),
    );
  }
}
