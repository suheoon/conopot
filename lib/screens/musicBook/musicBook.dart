import 'package:conopot/components/bottom_nav_bar.dart';
import 'package:conopot/constants.dart';
import 'package:conopot/models/musicSearchItem.dart';
import 'package:conopot/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'dart:convert';
import 'dart:core';

class MusicBookScreen extends StatefulWidget {
  @override
  State<MusicBookScreen> createState() => _MusicBookScreenState();
}

class _MusicBookScreenState extends State<MusicBookScreen> {
  int tabIndex = 1; // TJ or 금영

  List<MusicSearchItem> _foundItems = [];
  List<MusicSearchItem> results = [];
  List<MusicSearchItem> tj_Song_List = [];
  List<MusicSearchItem> ky_Song_List = [];

  Future<String> getTJMusics() async {
    return await rootBundle.loadString('assets/musics/musicbook_TJ.txt');
  }

  Future<String> getKYMusics() async {
    return await rootBundle.loadString('assets/musics/musicbook_KY.txt');
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    String TJMusics = await getTJMusics();
    String KYMusics = await getKYMusics();

    LineSplitter ls = new LineSplitter();
    List<String> contents = ls.convert(TJMusics);

    //문자열 파싱 -> MusicSearchItem
    late String title, singer, songNumber;
    for (String str in contents) {
      int start = 0, end = 0;

      for (int i = 0; i < 3; i++) {
        end = str.indexOf('^', start);
        if (start == end) continue;
        String tmp = str.substring(start, end);
        start = end + 1;

        if (i == 0)
          title = tmp;
        else if (i == 1)
          singer = tmp;
        else
          songNumber = tmp;
      }
      tj_Song_List.add(MusicSearchItem(
          title: title, singer: singer, songNumber: songNumber));
    }
    _foundItems = tj_Song_List;

    contents = ls.convert(KYMusics);

    //문자열 파싱 -> MusicSearchItem
    for (String str in contents) {
      int start = 0, end = 0;

      for (int i = 0; i < 3; i++) {
        end = str.indexOf('^', start);
        if (start == end) continue;
        String tmp = str.substring(start, end);
        start = end + 1;

        if (i == 0)
          title = tmp;
        else if (i == 1)
          singer = tmp;
        else
          songNumber = tmp;
      }
      ky_Song_List.add(MusicSearchItem(
          title: title, singer: singer, songNumber: songNumber));
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double widthSize = SizeConfig.screenWidth / 10;

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // back button 숨기기 위함

          title: TabBar(
            isScrollable: true,
            onTap: (index) {
              setState(() {
                tabIndex = index + 1;
                _foundItems = (tabIndex == 1) ? tj_Song_List : ky_Song_List;
                print(_foundItems);
              });
            },
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Color(0xFF7B61FF),
            tabs: [
              Text(
                'TJ',
                style: TextStyle(
                  color: (tabIndex == 1) ? kPrimaryColor : kTextLightColor,
                  fontSize: 18,
                ),
              ),
              Text(
                '금영',
                style: TextStyle(
                  color: (tabIndex == 2) ? kPrimaryColor : kTextLightColor,
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
                    setState(() {
                      _runFilter(text, 1);
                    }),
                  },
                  decoration: InputDecoration(
                      hintText: '검색', suffixIcon: Icon(Icons.search)),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: _foundItems.isNotEmpty
                      ? ListView.builder(
                          itemCount: _foundItems.length,
                          itemBuilder: (context, index) => Card(
                            color: Colors.white,
                            elevation: 1,
                            child: ListTile(
                              leading: Text(
                                _foundItems[index].songNumber,
                              ),
                              title: Text(_foundItems[index].title),
                              subtitle: Text(_foundItems[index].singer),
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
                    setState(() {
                      _runFilter(text, 2);
                    }),
                  },
                  decoration: InputDecoration(
                      hintText: '검색', suffixIcon: Icon(Icons.search)),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: _foundItems.isNotEmpty
                      ? ListView.builder(
                          itemCount: _foundItems.length,
                          itemBuilder: (context, index) => Card(
                            color: Colors.white,
                            elevation: 1,
                            child: ListTile(
                              leading: Text(
                                _foundItems[index].songNumber,
                              ),
                              title: Text(_foundItems[index].title),
                              subtitle: Text(_foundItems[index].singer),
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
    );
  }

  void _runFilter(String enteredKeyword, int _tabIndex) {
    if (_tabIndex == 1) {
      //TJ
      if (enteredKeyword.isEmpty) {
        results = tj_Song_List;
      } else {
        results = tj_Song_List
            .where((string) =>
                string.title.contains(enteredKeyword) ||
                string.singer.contains(enteredKeyword))
            .toList();
      }
    } else {
      //KY
      if (enteredKeyword.isEmpty) {
        results = ky_Song_List;
      } else {
        results = ky_Song_List
            .where((string) =>
                string.title.contains(enteredKeyword) ||
                string.singer.contains(enteredKeyword))
            .toList();
      }
    }
    _foundItems = results;
    print(_foundItems.length);
  }
}
