import 'package:conopot/components/bottom_nav_bar.dart';
import 'package:conopot/constants.dart';
import 'package:conopot/models/MusicSearchItem.dart';
import 'package:conopot/models/MusicSearchItemLists.dart';
import 'package:conopot/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'dart:convert';
import 'dart:core';
import 'package:provider/provider.dart';

class MusicBookScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    MusicSearchItemLists().init();
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
                musicList.changeTabIndex(index: index + 1);
              },
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Color(0xFF7B61FF),
              tabs: [
                Text(
                  'TJ',
                  style: TextStyle(
                    color: (musicList.tabIndex == 1)
                        ? kPrimaryColor
                        : kTextLightColor,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '금영',
                  style: TextStyle(
                    color: (musicList.tabIndex == 2)
                        ? kPrimaryColor
                        : kTextLightColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    onChanged: (text) => {
                      musicList.runFilter(text, 1),
                    },
                    decoration: InputDecoration(
                        hintText: '검색', suffixIcon: Icon(Icons.search)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: musicList.foundItems.isNotEmpty
                        ? ListView.builder(
                            itemCount: musicList.foundItems.length,
                            itemBuilder: (context, index) => Card(
                              color: Colors.white,
                              elevation: 1,
                              child: ListTile(
                                leading: Text(
                                  musicList.foundItems[index].songNumber,
                                ),
                                title: Text(musicList.foundItems[index].title),
                                subtitle:
                                    Text(musicList.foundItems[index].singer),
                              ),
                            ),
                          )
                        : Text(
                            '검색 결과가 없습니다',
                            style: TextStyle(fontSize: 18),
                          ),
                  )
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    onChanged: (text) => {
                      musicList.runFilter(text, 2),
                    },
                    decoration: InputDecoration(
                        hintText: '검색', suffixIcon: Icon(Icons.search)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: musicList.foundItems.isNotEmpty
                        ? ListView.builder(
                            itemCount: musicList.foundItems.length,
                            itemBuilder: (context, index) => Card(
                              color: Colors.white,
                              elevation: 1,
                              child: ListTile(
                                leading: Text(
                                  musicList.foundItems[index].songNumber,
                                ),
                                title: Text(musicList.foundItems[index].title),
                                subtitle:
                                    Text(musicList.foundItems[index].singer),
                              ),
                            ),
                          )
                        : Text(
                            '검색 결과가 없습니다',
                            style: TextStyle(fontSize: 18),
                          ),
                  )
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
