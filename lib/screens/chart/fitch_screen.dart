import 'package:conopot/components/bottom_nav_bar.dart';
import 'package:conopot/constants.dart';
import 'package:conopot/models/MusicSearchItemLists.dart';
import 'package:conopot/screens/chart/components/fitchSearchBar.dart';
import 'package:conopot/screens/chart/components/fitchSearchList.dart';
import 'package:conopot/screens/fitch/components/dropdownOption.dart';
import 'package:conopot/screens/musicBook/components/searchBar.dart';
import 'package:conopot/screens/musicBook/components/searchList.dart';
import 'package:conopot/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FitchScreen extends StatefulWidget {
  FitchScreen({Key? key}) : super(key: key);

  @override
  State<FitchScreen> createState() => _FitchScreenState();
}

class _FitchScreenState extends State<FitchScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double widthSize = SizeConfig.screenWidth / 10;

    return Consumer<MusicSearchItemLists>(
      builder: (
        context,
        musicList,
        child,
      ) =>
          Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // back button 숨기기 위함
        ),
        body: Column(
          children: [
            FitchSearchBar(musicList: musicList),
            DropdownOption(musicList: musicList),
            FitchSearchList(musicList: musicList),
          ],
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}
