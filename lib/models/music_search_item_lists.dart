import 'dart:convert';
import 'dart:math';
import 'package:conopot/models/pitch_music.dart';
import 'package:conopot/models/music_search_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MusicSearchItemLists extends ChangeNotifier {
  List<MusicSearchItem> foundItems = [];
  List<MusicSearchItem> results = [];
  List<MusicSearchItem> tjSongList = [];
  List<MusicSearchItem> kySongList = [];
  List<MusicSearchItem> tjChartSongList = [];
  List<MusicSearchItem> kyChartSongList = [];
  List<FitchMusic> highestSongList = [];
  List<FitchMusic> highestFoundItems = [];
  List<FitchMusic> highestResults = [];
  List<bool> isChecked = [];
  List<FitchMusic> checkedMusics = [];

  int tabIndex = 1; // TJ or 금영

  int userPitch = 23;

  int userMaxPitch = -1;

  void changeUserPitch({required int pitch}) {
    userPitch = pitch;
    notifyListeners();
  }

  void getMaxPitch() {
    userMaxPitch = -1;

    /// 사용자가 선택한 노래가 존재한다면
    if (checkedMusics.isNotEmpty) {
      for (FitchMusic iter in checkedMusics) {
        userMaxPitch = max(userMaxPitch, iter.pitchNum);
      }
    }
    notifyListeners();
  }

  void changeSortOption({required String? option}) {
    ///option에 따라 현재 리스트에서 보여지는 highestFoundItems를 정렬한다.
    if (option == '높은 음정순') {
      highestFoundItems.sort(((a, b) => b.pitchNum.compareTo(a.pitchNum)));
    } else if (option == '낮은 음정순') {
      highestFoundItems.sort(((a, b) => a.pitchNum.compareTo(b.pitchNum)));
    } else if (option == '내 음역대의 노래') {
      highestResults = highestSongList
          .where((string) => (userPitch - 2 <= string.pitchNum &&
              string.pitchNum <= userPitch))
          .toList();
      highestFoundItems = highestResults;
    } else {
      highestResults = highestSongList;
      highestFoundItems = highestResults;
    }

    notifyListeners();
  }

  Future<String> getTJMusics() async {
    return await rootBundle.loadString('assets/musics/musicbook_TJ.txt');
  }

  Future<String> getTJMusicChart() async {
    return await rootBundle.loadString('assets/musics/chart_TJ.txt');
  }

  Future<String> getKYMusics() async {
    return await rootBundle.loadString('assets/musics/musicbook_KY.txt');
  }

  Future<String> getKYMusicChart() async {
    return await rootBundle.loadString('assets/musics/chart_KY.txt');
  }

  Future<String> getHighMusics() async {
    return await rootBundle.loadString('assets/musics/music_highest_key.txt');
  }

  void initFitch() {
    highestFoundItems = highestSongList;
  }

  void initChart() {
    foundItems = tjChartSongList;
  }

  void initBook() {
    foundItems = tjSongList;
  }

  void initPitchMusic({required int pitchNum}) {
    highestResults = [];
    highestResults = highestSongList
        .where((string) => (pitchNum - 1 <= string.pitchNum &&
            string.pitchNum <= pitchNum + 1))
        .toList();
    highestFoundItems = highestResults;
  }

  // 프로그램 실행 시, 노래방 책 List 초기화 (TJ, KY txt -> List)
  void init() async {
    //사용자 음정 불러오기
    final storage = new FlutterSecureStorage();
    String? value = await storage.read(key: 'userPitch');
    if (value != null) userPitch = int.parse(value);

    String TJMusics = await getTJMusics();
    String TJMusicChart = await getTJMusicChart();
    String KYMusics = await getKYMusics();
    String KYMusicChart = await getKYMusicChart();
    String HighMusics = await getHighMusics();

    LineSplitter ls = new LineSplitter();

    List<String> contents = ls.convert(TJMusics);

    parseMusics(contents, tjSongList);
    foundItems = tjSongList;

    contents = ls.convert(KYMusics);
    parseMusics(contents, kySongList);

    contents = ls.convert(TJMusicChart);
    parseMusics(contents, tjChartSongList);

    contents = ls.convert(KYMusicChart);
    parseMusics(contents, kyChartSongList);

    //최고음 db 파싱
    contents = ls.convert(HighMusics);

    late String tj_title, tj_singer, tj_songNumber;
    late String ky_title, ky_singer, ky_songNumber;
    late String gender, fitch;
    late int fitchNum;

    //문자열 파싱 -> MusicSearchItem
    for (String str in contents) {
      int start = 0, end = 0;

      for (int i = 0; i < 9; i++) {
        end = str.indexOf('^', start);
        if (start == end) continue;
        String tmp = str.substring(start, end);
        start = end + 1;

        if (i == 0)
          tj_title = tmp;
        else if (i == 1)
          tj_singer = tmp;
        else if (i == 2)
          tj_songNumber = tmp;
        else if (i == 3)
          ky_title = tmp;
        else if (i == 4)
          ky_singer = tmp;
        else if (i == 5)
          ky_songNumber = tmp;
        else if (i == 6)
          gender = tmp;
        else if (i == 7)
          fitch = tmp;
        else
          fitchNum = int.parse(tmp);
      }

      highestSongList.add(FitchMusic(
          tj_title: tj_title,
          tj_singer: tj_singer,
          tj_songNumber: tj_songNumber,
          ky_title: ky_title,
          ky_singer: ky_singer,
          ky_songNumber: ky_songNumber,
          gender: gender,
          pitch: fitch,
          pitchNum: fitchNum));
      highestFoundItems = highestSongList;

      isChecked = List<bool>.filled(highestFoundItems.length, false);
      notifyListeners();
    }
  }

  void changeTabIndex({required int index}) {
    tabIndex = index;
    foundItems = (index == 1) ? tjSongList : kySongList;
    notifyListeners();
  }

  void changeChartTabIndex({required int index}) {
    tabIndex = index;
    foundItems = (index == 1) ? tjChartSongList : kyChartSongList;
    notifyListeners();
  }

  // 검색 필터링 기능(일반검색)
  void runFilter(String enteredKeyword, int _tabIndex) {
    results = [];
    if (_tabIndex == 1) {
      //TJ
      if (enteredKeyword.isEmpty) {
        results = tjSongList;
      } else {
        results = tjSongList
            .where((string) =>
                string.title.contains(enteredKeyword) ||
                string.singer.contains(enteredKeyword))
            .toList();
      }
    } else {
      //KY
      if (enteredKeyword.isEmpty) {
        results = kySongList;
      } else {
        results = kySongList
            .where((string) =>
                string.title.contains(enteredKeyword) ||
                string.singer.contains(enteredKeyword))
            .toList();
      }
    }
    foundItems = results;

    notifyListeners();
  }

  // 검색 필터링 기능(인기검색)
  void runHighFitchFilter(String enteredKeyword) {
    highestResults = [];
    if (enteredKeyword.isEmpty) {
      highestResults = highestSongList;
    } else {
      highestResults = highestSongList
          .where((string) =>
              string.tj_title.contains(enteredKeyword) ||
              string.tj_singer.contains(enteredKeyword))
          .toList();
    }
    highestFoundItems = highestResults;

    notifyListeners();
  }

  void parseMusics(List<String> contents, List<MusicSearchItem> musicList) {
    late String title, singer, songNumber;
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
      musicList.add(MusicSearchItem(
          title: title, singer: singer, songNumber: songNumber));
    }
  }
}
