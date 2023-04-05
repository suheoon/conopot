import 'package:conopot/firebase/analytics_config.dart';
import 'package:conopot/models/music_state.dart';
import 'package:conopot/screens/chart/components/pitch_search_bar.dart';
import 'package:conopot/screens/chart/components/pitch_search_list.dart';
import 'package:conopot/screens/pitch/components/pitch_dropdown_option.dart';
import 'package:conopot/global/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PitchScreen extends StatefulWidget {
  PitchScreen({Key? key}) : super(key: key);

  @override
  State<PitchScreen> createState() => _PitchScreenState();
}

class _PitchScreenState extends State<PitchScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double widthSize = SizeConfig.screenWidth / 10;
    Analytics_config().pitchMeasurePageView();

    return Consumer<MusicState>(
      builder: (
        context,
        musicList,
        child,
      ) =>
          Scaffold(
        appBar: AppBar(
          title: Text(
            '노래 최고음 검색',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context); //뒤로가기
            },
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            PitchSearchBar(
              musicList: musicList,
            ),
            PitchDropdownOption(),
            PitchSearchList(),
          ],
        ),
      ),
    );
  }
}
