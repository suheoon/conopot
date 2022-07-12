import 'dart:convert';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:conopot/config/analytics_config.dart';
import 'package:conopot/config/constants.dart';
import 'package:conopot/models/music_search_item_lists.dart';
import 'package:conopot/models/pitch_music.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'note.dart';

class NoteData extends ChangeNotifier {
  List<Note> notes = [];
  bool visibleOfTextField = false;
  late FitchMusic clickedItem;
  int selectedIndex = -1;
  bool emptyCheck = false;

  final storage = new FlutterSecureStorage();

  void initNotes(List<FitchMusic> combinedSongList) async {
    // Read all values
    String? allValues = await storage.read(key: 'notes');
    if (allValues != null) {
      var noteJson = jsonDecode(allValues) as List;
      List<Note> savedNote =
          noteJson.map((noteIter) => Note.fromJson(noteIter)).toList();

      notes = savedNote;

      //print(notes);

      // //합친 곡 리스트 순회하며 노트에 있는 곡인지 체크
      // for (int i = 0; i < combinedSongList.length; i++) {
      //   if (savedNote.contains(combinedSongList[i].tj_songNumber)) {
      //     String? memo =
      //         await storage.read(key: combinedSongList[i].tj_songNumber);
      //     Note note = Note(
      //         combinedSongList[i].tj_title,
      //         combinedSongList[i].tj_singer,
      //         combinedSongList[i].tj_songNumber,
      //         combinedSongList[i].ky_title,
      //         combinedSongList[i].ky_singer,
      //         combinedSongList[i].ky_songNumber,
      //         combinedSongList[i].gender,
      //         combinedSongList[i].pitch,
      //         combinedSongList[i].pitchNum,
      //         memo!,
      //         0);
      //     notes.add(note);
      //   }
      // }
    }

    int memoCnt = 0; //전체 노트 중 메모를 한 노트의 수
    for (Note note in notes) {
      if (note.memo != null && note.memo != "") {
        memoCnt++;
      }
    }

    //!event : 노트 뷰 조회
    Analytics_config.analytics.logEvent('애창곡 노트 뷰 - 노트 뷰  조회',
        eventProperties: {'노트 개수': notes.length, '메모 노트 개수': memoCnt});

    notifyListeners();
  }

  //!event : 애창곡 노트 뷰 - 곡 추가
  void addNoteEvent() {
    Analytics_config.analytics
        .logEvent('애창곡 노트 뷰 - 곡 추가', eventProperties: {'노트 개수': notes.length});
  }

  //!event : 애창곡 노트 뷰 - 곡 상세 정보 조회
  void viewNoteEvent(Note note) {
    Analytics_config.analytics
        .logEvent('애창곡 노트 뷰 - 곡 상세 정보 조회', eventProperties: {
      '곡 이름': note.tj_title,
      '가수 이름': note.tj_singer,
      'TJ 번호': note.tj_songNumber,
      '금영 번호': note.ky_songNumber,
      '최고음': note.pitch,
      '매칭 여부': (note.tj_songNumber == note.ky_songNumber),
      '메모 여부': note.memo
    });
  }

  //!event: 곡 추가 뷰 - 리스트 클릭 시
  void addSongClickEvent(FitchMusic fitchMusic) {
    Analytics_config.analytics.logEvent('곡 추가 뷰 - 리스트 클릭 시', eventProperties: {
      '노트 개수': notes.length,
      '곡 이름': fitchMusic.tj_title,
      '가수 이름': fitchMusic.tj_singer,
      'TJ 번호': fitchMusic.tj_songNumber,
      '금영 번호': fitchMusic.ky_songNumber,
      '최고음': fitchMusic.pitch,
      '매칭 여부': (fitchMusic.tj_songNumber == fitchMusic.ky_songNumber),
    });
  }

  //!event: 곡 상세정보 뷰 - 노트 삭제
  void noteDeleteEvent(Note note) {
    Analytics_config.analytics.logEvent('곡 상세정보 뷰 - 노트 삭제', eventProperties: {
      '노트 개수': notes.length,
      '곡 이름': note.tj_title,
      '가수 이름': note.tj_singer,
      'TJ 번호': note.tj_songNumber,
      '금영 번호': note.ky_songNumber,
      '최고음': note.pitch,
      '매칭 여부': (note.tj_songNumber == note.ky_songNumber),
    });
  }

  //!event: 곡 상세정보 뷰 - 최고음 들어보기
  void pitchListenEvent(String pitch) {
    Analytics_config.analytics
        .logEvent('곡 상세정보 뷰 - 최고음 들어보기', eventProperties: {
      '최고음': pitch,
    });
  }

  //!event: 곡 상세정보 뷰 - 유튜브 클릭
  void youtubeClickEvent(Note note) {
    Analytics_config.analytics.logEvent('곡 상세정보 뷰 - 유튜브 클릭',
        eventProperties: {'곡 이름': note.tj_title, '메모': note.memo});
  }

  //!event: 곡 상세정보 뷰 - 금영 검색
  void kySearchEvent(String tjNumber) {
    Analytics_config.analytics.logEvent('곡 상세정보 뷰 - 금영 검색',
        eventProperties: {'노트 개수': notes.length, 'TJ 번호': tjNumber});
  }

  //!event: 곡 상세정보 뷰 - 메모 수정
  void songMemoEditEvent(String title) {
    Analytics_config.analytics
        .logEvent('곡 상세정보 뷰 - 메모 수정', eventProperties: {'곡 이름': title});
  }

  //local storage 저장 (key : songNum, value : memo)
  //예외 : 이미 있는 노래를 추가할 경우
  Future<void> addNote(String memo) async {
    Note note = Note(
        clickedItem.tj_title,
        clickedItem.tj_singer,
        clickedItem.tj_songNumber,
        clickedItem.ky_title,
        clickedItem.ky_singer,
        clickedItem.ky_songNumber,
        clickedItem.gender,
        clickedItem.pitch,
        clickedItem.pitchNum,
        memo,
        0);

    bool flag = false;
    for (Note iter_note in notes) {
      if (iter_note.tj_songNumber == clickedItem.tj_songNumber) {
        flag = true;
        break;
      }
    }
    if (!flag) {
      notes.add(note);
      await storage.write(key: 'notes', value: jsonEncode(notes));

      //!event: 곡 추가 뷰 - 노트 추가 이벤트
      Analytics_config.analytics
          .logEvent('곡 추가 뷰 - 노트 추가 이벤트', eventProperties: {
        '곡 이름': note.tj_title,
        '가수 이름': note.tj_singer,
        'TJ 번호': note.tj_songNumber,
        '금영 번호': note.ky_songNumber,
        '최고음': note.pitch,
        '매칭 여부': (note.tj_songNumber == note.ky_songNumber),
        '메모 여부': note.memo
      });
    } else {
      emptyCheck = true;
    }

    notifyListeners();
  }

  Future<void> addNodeBySongNumber(
      String songNumber, List<FitchMusic> musicList) async {
    for (FitchMusic fitchMusic in musicList) {
      if (fitchMusic.tj_songNumber == songNumber) {
        Note note = Note(
            fitchMusic.tj_title,
            fitchMusic.tj_singer,
            fitchMusic.tj_songNumber,
            fitchMusic.ky_title,
            fitchMusic.ky_singer,
            fitchMusic.ky_songNumber,
            fitchMusic.gender,
            fitchMusic.pitch,
            fitchMusic.pitchNum,
            "",
            0);

        bool flag = false;
        for (Note iter_note in notes) {
          if (iter_note.tj_songNumber == fitchMusic.tj_songNumber) {
            flag = true;
            break;
          }
        }
        if (!flag) {
          notes.add(note);
          await storage.write(key: 'notes', value: jsonEncode(notes));

          //!event: 곡 추가 뷰 - 노트 추가 이벤트
          Analytics_config.analytics
              .logEvent('검색 - 노트 추가 이벤트', eventProperties: {
            '곡 이름': note.tj_title,
            '가수 이름': note.tj_singer,
            'TJ 번호': note.tj_songNumber,
            '금영 번호': note.ky_songNumber,
            '최고음': note.pitch,
            '매칭 여부': (note.tj_songNumber == note.ky_songNumber),
            '메모 여부': note.memo
          });
        } else {
          emptyCheck = true;
        }

        notifyListeners();

        break;
      }
    }
  }

  Future<void> editNote(Note note, String memo) async {
    note.memo = memo;
    for (Note no in notes) {
      if (note.tj_songNumber == no.tj_songNumber) {
        no.memo = memo;
      }
    }
    await storage.write(key: 'notes', value: jsonEncode(notes));
    //await storage.write(key: note.tj_songNumber, value: memo);
    notifyListeners();
  }

  //local storage 에도 삭제 작업 필요
  Future<void> deleteNote(Note note) async {
    notes.remove(note);
    await storage.write(key: 'notes', value: jsonEncode(notes));
    //await storage.delete(key: note.tj_songNumber);
    notifyListeners();
  }

  void hideTextFiled() {
    this.visibleOfTextField = false;
    notifyListeners();
  }

  void showTextFiled() {
    this.visibleOfTextField = true;
    notifyListeners();
  }

  void initEmptyCheck() {
    emptyCheck = false;
    notifyListeners();
  }

  void setSelectedIndex(int idx) {
    if (this.selectedIndex == idx) {
      this.selectedIndex = -1;
    } else {
      this.selectedIndex = idx;
    }
    notifyListeners();
  }

  void pluskeyAdjustment(int idx) {
    notes[idx].keyAdjustment++;
    notifyListeners();
  }

  void minuskeyAdjustment(int idx) {
    notes[idx].keyAdjustment--;
    notifyListeners();
  }

  void changeKySongNumber(Note note, String kySongNumber) {
    int idx = notes.indexOf(note);
    notes[idx].ky_songNumber = kySongNumber;
    notifyListeners();
  }

  Future<void> reorderEvent() async {
    await storage.write(key: 'notes', value: jsonEncode(notes));
  }
}
