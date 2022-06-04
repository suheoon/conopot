import 'dart:math';

import 'package:conopot/components/custom_page_route.dart';
import 'package:conopot/constants.dart';
import 'package:conopot/models/FitchMusic.dart';
import 'package:conopot/models/MusicSearchItemLists.dart';
import 'package:conopot/screens/chart/components/fitchSearchBar.dart';
import 'package:conopot/screens/fitch/components/dropdownOption.dart';
import 'package:conopot/screens/fitch/components/fitchCheckBox.dart';
import 'package:conopot/screens/fitch/components/fitchDropdown.dart';
import 'package:conopot/screens/fitch/fitchResult.dart';
import 'package:conopot/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FitchChoice extends StatelessWidget {
  const FitchChoice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Consumer<MusicSearchItemLists>(
        builder: (context, musicList, child) => Container(
              child: Scaffold(
                appBar: AppBar(
                  leading: BackButton(color: Colors.black),
                  title: Text(
                    '음역대 측정',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: SizeConfig.defaultSize * 3,
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                        ),
                        children: [
                          TextSpan(
                            text: '이노래, ',
                            style: TextStyle(
                              color: Color(0xFF7B61FF),
                            ),
                          ),
                          TextSpan(
                            text: '가능하세요?',
                            style: TextStyle(
                              color: kTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.defaultSize * 2,
                    ),
                    Text(
                      '전 구간 부를 수 있는 노래만 선택해주세요!',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Color(0xFF4F4F4F),
                      ),
                    ),
                    FitchSearchBar(musicList: musicList),
                    FitchDropdown(musicList: musicList),
                    FitchCheckBox(musicList: musicList),
                  ],
                ),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () => {
                    musicList.getMaxFitch(),
                    if (musicList.userMaxFitch == -1)
                      {
                        AlertDialog(
                          title: Text('최소 하나 이상 선택해주세요!'),
                        ),
                        print(1),
                      }
                    else
                      {
                        Navigator.push(
                          context,
                          CustomPageRoute(
                            child:
                                FitchResult(fitchLevel: musicList.userMaxFitch),
                          ),
                        ),
                      }
                  },
                  icon: Icon(Icons.check_sharp),
                  label: Text('선택 완료'),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              ),
            ));
  }
}
