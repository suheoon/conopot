import 'package:conopot/firebase/analytics_config.dart';
import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/models/music_state.dart';
import 'package:conopot/screens/chart/components/pitch_search_bar.dart';
import 'package:conopot/screens/pitch/components/pitch_checkbox.dart';
import 'package:conopot/screens/pitch/components/pitch_dropdown.dart';
import 'package:conopot/screens/pitch/pitch_result.dart';
import 'package:conopot/global/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PitchChoice extends StatefulWidget {
  const PitchChoice({Key? key}) : super(key: key);

  @override
  State<PitchChoice> createState() => _PitchChoiceState();
}

class _PitchChoiceState extends State<PitchChoice> {
  @override
  void initState() {
    super.initState();
    // !event : 간접 음역대 측정뷰 - 페이지뷰
    Analytics_config().event('간접_음역대_측정뷰__페이지뷰', {});
  }

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return Consumer<MusicState>(
        builder: (context, musicList, child) => Container(
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(defaultSize * 4),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BackButton(
                            color: kPrimaryWhiteColor,
                            onPressed: () {
                              // !event : 간접 음역대 측정뷰 - 백버튼
                              Analytics_config()
                                  .event('간접_음역대_측정뷰__백버튼_클릭', {});
                              Navigator.pop(context);
                            },
                          ),
                          Expanded(child: PitchSearchBar(musicList: musicList))
                        ]),
                    centerTitle: false,
                  ),
                ),
                body: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: defaultSize * 3,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: defaultSize * 1.5),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "이 노래, 부를 수 있으세요?",
                                style: TextStyle(
                                    color: kPrimaryLightWhiteColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: defaultSize * 2),
                              ),
                              SizedBox(height: defaultSize),
                              Text("전 구간 끝까지 부를 수 있는 노래를 골라 주시면",
                                  style: TextStyle(
                                      color: kPrimaryLightWhiteColor,
                                      fontWeight: FontWeight.w200,
                                      fontSize: defaultSize * 1.5)),
                              SizedBox(height: defaultSize * 0.5),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: "음역대를 측정해 드릴게요!",
                                    style: TextStyle(
                                        color: kPrimaryLightWhiteColor,
                                        fontWeight: FontWeight.w200,
                                        fontSize: defaultSize * 1.5)),
                              ]))
                            ]),
                      ),
                      PitchDropdown(musicList: musicList),
                      PitchCheckBox(),
                    ],
                  ),
                ),
                floatingActionButton: keyboardIsOpened
                    ? null
                    : FloatingActionButton.extended(
                        onPressed: () => {
                          musicList.getMaxPitch(),
                          if (musicList.userMaxPitch == -1)
                            {
                              AlertDialog(
                                title: Text('최소 하나 이상 선택해주세요!'),
                              ),
                            }
                          else
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PitchResult(
                                        fitchLevel: musicList.userMaxPitch)),
                              ),
                            }
                        },
                        backgroundColor: kMainColor,
                        icon: Icon(Icons.check_sharp),
                        label: Text('선택 완료'),
                      ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              ),
            ));
  }
}
