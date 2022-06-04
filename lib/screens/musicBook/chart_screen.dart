import 'package:conopot/constants.dart';
import 'package:conopot/models/MusicSearchItemLists.dart';
import 'package:conopot/screens/musicBook/components/chartSearchList.dart';
import 'package:conopot/screens/musicBook/components/chartSearchBar.dart';
import 'package:conopot/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({Key? key}) : super(key: key);

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
            leading: BackButton(color: Colors.black),
            automaticallyImplyLeading: false, // back button 숨기기 위함
            centerTitle: true,

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
                  ChartSearchList(musicList: musicList),
                ],
              ),
              Column(
                children: [
                  ChartSearchList(musicList: musicList),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
