import 'package:conopot/firebase/analytics_config.dart';
import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/models/music_state.dart';
import 'package:conopot/models/note_state.dart';
import 'package:conopot/models/pitch_item.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/screens/pitch/pitch_measure.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class PitchSearchList extends StatelessWidget {
  double defaultSize = SizeConfig.defaultSize;
  double screenHeight = SizeConfig.screenHeight;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Consumer<MusicState>(
      builder: (
        context,
        musicList,
        child,
      ) =>
          Expanded(
              child: musicList.highestFoundItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: musicList.highestFoundItems.length,
                      itemBuilder: (context, index) {
                        String songNumber =
                            musicList.highestFoundItems[index].tj_songNumber;
                        String title =
                            musicList.highestFoundItems[index].tj_title;

                        return ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: Card(
                            margin: EdgeInsets.fromLTRB(
                                defaultSize, 0, defaultSize, defaultSize * 0.5),
                            color: kPrimaryLightBlackColor,
                            elevation: 1,
                            child: ListTile(
                                leading: SizedBox(
                                  width: defaultSize * 6.5,
                                  child: Center(
                                    child: Text(
                                      pitchNumToString[musicList
                                          .highestFoundItems[index].pitchNum],
                                      style: TextStyle(
                                        color: kMainColor,
                                        fontSize: defaultSize * 1.1,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  musicList.highestFoundItems[index].tj_title,
                                  style: TextStyle(
                                    color: kPrimaryWhiteColor,
                                    fontSize: defaultSize * 1.4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  musicList.highestFoundItems[index].tj_singer,
                                  style: TextStyle(
                                      color: kPrimaryLightWhiteColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: defaultSize * 1.2),
                                ),
                                onTap: () {
                                  // !event : 음역대 측정 결과 뷰 - 내 최고음 주변의 인기곡들
                                  Analytics_config()
                                      .event('음역대_측정_결과_뷰__노트_추가', {});
                                  Provider.of<NoteState>(context, listen: false)
                                      .showAddNoteDialog(
                                          context, songNumber, title);
                                }),
                          ),
                        );
                      })
                  : SingleChildScrollView(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: screenHeight * 0.25),
                            Text(
                              "내 최고음 근처의 인기곡들이 없어요",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: kPrimaryLightWhiteColor,
                                  fontSize: defaultSize * 1.5),
                            ),
                            SizedBox(height: SizeConfig.defaultSize),
                            ElevatedButton(
                              onPressed: () {
                                int count = 0;
                                Navigator.of(context)
                                    .popUntil((_) => count++ >= 2);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PitchMeasure()));
                              },
                              child: Text(
                                "다시 측정하기",
                                style: TextStyle(
                                    color: kPrimaryBlackColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  side: BorderSide(color: kPrimaryBlackColor),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0))),
                            ),
                          ],
                        ),
                      ),
                    )),
    );
  }
}
