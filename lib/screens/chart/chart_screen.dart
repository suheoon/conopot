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

class ChartScreen extends StatefulWidget {
  ChartScreen({Key? key}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
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
          DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false, // back button 숨기기 위함

            title: TabBar(
              isScrollable: true,
              onTap: (index) {
                musicList.changeChartTabIndex(index: index + 1);
              },
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Color(0xFF7B61FF),
              tabs: [
                Text(
                  'TJ',
                  style: TextStyle(
                    color: (musicList.tabIndex == 1)
                        ? kTextColor
                        : kTextLightColor,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '금영',
                  style: TextStyle(
                    color: (musicList.tabIndex == 2)
                        ? kTextColor
                        : kTextLightColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  FitchSearchBar(musicList: musicList),
                  FitchSearchList(musicList: musicList),
                ],
              ),
              Column(
                children: [
                  FitchSearchBar(musicList: musicList),
                  FitchSearchList(musicList: musicList),
                ],
              ),
            ],
          ),
          bottomNavigationBar: BottomNavBar(),
        ),
      ),
    );
  }
}
