import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
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

  Amplitude analytics = Amplitude.getInstance(instanceName: "project");

  void initNotes(List<FitchMusic> combinedSongList) async {
    //Amplitude Init 부분

    // Initialize SDK
    analytics.init('cf1298f461883c1cbf97daeb0393b987');

    // Enable COPPA privacy guard. This is useful when you choose not to report sensitive user information.
    analytics.enableCoppaControl();

    // Set user Id
    analytics.setUserId("test_user");
    // Turn on automatic session events
    analytics.trackingSessionEvents(true);

    // Log an event
    analytics.logEvent('MyApp startup',
        eventProperties: {'friend_num': 10, 'is_heavy_user': true});

    // Identify
    final Identify identify1 = Identify()
      ..set('identify_test',
          'identify sent at ${DateTime.now().millisecondsSinceEpoch}')
      ..add('identify_count', 1);
    analytics.identify(identify1);

    // Set group
    analytics.setGroup('orgId', 15);

    // Group identify
    final Identify identify2 = Identify()..set('identify_count', 1);
    analytics.groupIdentify('orgId', '15', identify2);
    // Read all values
    Map<String, String> allValues = await storage.readAll();

    //합친 곡 리스트 순회하며 노트에 있는 곡인지 체크
    for (int i = 0; i < combinedSongList.length; i++) {
      if (allValues.containsKey(combinedSongList[i].tj_songNumber)) {
        String? memo =
            await storage.read(key: combinedSongList[i].tj_songNumber);
        Note note = Note(
            combinedSongList[i].tj_title,
            combinedSongList[i].tj_singer,
            combinedSongList[i].tj_songNumber,
            combinedSongList[i].ky_title,
            combinedSongList[i].ky_singer,
            combinedSongList[i].ky_songNumber,
            combinedSongList[i].gender,
            combinedSongList[i].pitch,
            combinedSongList[i].pitchNum,
            memo!,
            0);
        notes.add(note);
      }
    }

    analytics
        .logEvent('Init', eventProperties: {'User_Song_Count': notes.length});

    notifyListeners();
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
      await storage.write(key: clickedItem.tj_songNumber, value: memo);
      notes.add(note);
    } else {
      emptyCheck = true;
    }

    analytics.logEvent('Song_Add',
        eventProperties: {'User_Song_add': note.tj_title});
    Amplitude.getInstance().uploadEvents();

    notifyListeners();
  }

  Future<void> editNote(Note note, String memo) async {
    note.memo = memo;
    await storage.write(key: note.tj_songNumber, value: memo);
    notifyListeners();
  }

  //local storage 에도 삭제 작업 필요
  Future<void> deleteNote(Note note) async {
    await storage.delete(key: note.tj_songNumber);
    notes.remove(note);
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

  void changeKySongNumber(int idx, String kySongNumber) {
    notes[idx].ky_songNumber = kySongNumber;
    notifyListeners();
  }
}
