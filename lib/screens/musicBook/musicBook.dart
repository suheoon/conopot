import 'dart:ui';

import 'package:conopot/components/bottom_nav_bar.dart';
import 'package:conopot/constants.dart';
import 'package:conopot/models/MusicSearchItemLists.dart';
import 'package:conopot/size_config.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:provider/provider.dart';

class MusicBookScreen extends StatelessWidget {
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
                musicList.changeTabIndex(index: index + 1);
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
                  SearchBar(musicList: musicList),
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                title: Text(
                                  musicList.foundItems[index].title,
                                ),
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
                  SearchBar(musicList: musicList),
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

class SearchBar extends StatelessWidget {
  final MusicSearchItemLists musicList;

  const SearchBar({required this.musicList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
        onChanged: (text) => {
          musicList.runFilter(text, musicList.tabIndex),
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: '제목 및 가수명을 검색하세요',
          contentPadding: EdgeInsets.all(0),
          suffixIcon: Icon(Icons.search),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            borderSide: BorderSide(
              width: 1,
              color: Color(0xFF7B61FF),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
        ),
      ),
    );
  }
}
