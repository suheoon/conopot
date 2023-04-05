import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/models/music_state.dart';
import 'package:conopot/models/youtube_player_state.dart';
import 'package:conopot/screens/note/add_note_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmptyNoteList extends StatelessWidget {
  double defaultSize = SizeConfig.defaultSize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "내 노래방 ",
                  style: TextStyle(
                    color: kPrimaryWhiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: defaultSize * 2,
                  ),
                ),
                TextSpan(
                    text: '애창곡',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: kMainColor,
                      fontSize: defaultSize * 2,
                    )),
                TextSpan(
                  text: "을",
                  style: TextStyle(
                    color: kPrimaryWhiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: defaultSize * 2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.defaultSize * 0.5,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "애창곡 노트",
                  style: TextStyle(
                    color: kMainColor,
                    fontWeight: FontWeight.w500,
                    fontSize: defaultSize * 2,
                  ),
                ),
                TextSpan(
                    text: '에 저장해 보세요',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: kPrimaryWhiteColor,
                      fontSize: defaultSize * 2,
                    )),
              ],
            ),
          ),
        ],
      ),
      SizedBox(
        height: defaultSize * 2.5,
      ),
      GestureDetector(
        onTap: () {
          Provider.of<MusicState>(context, listen: false).initChart();
          Provider.of<YoutubePlayerState>(context, listen: false).closePlayer();
          Provider.of<YoutubePlayerState>(context, listen: false).refresh();
          Provider.of<MusicState>(context, listen: false)
              .initCombinedBook();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNoteScreen(),
            ),
          );
        },
        child: Container(
          width: defaultSize * 22.8,
          height: defaultSize * 4,
          decoration: BoxDecoration(
              color: kMainColor,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: kPrimaryWhiteColor),
                Text(
                  "노래 추가하기",
                  style: TextStyle(
                      color: kPrimaryWhiteColor,
                      fontSize: defaultSize * 1.5,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      )
    ]));
  }
}
