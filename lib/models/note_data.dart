import 'package:conopot/config/constants.dart';
import 'package:conopot/models/pitch_music.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'note.dart';

class NoteData extends ChangeNotifier {
  List<Note> notes = [];
  bool visibleOfTextField = false;
  late FitchMusic musicSearchItem;
  int selectedIndex = -1;
  bool emptyCheck = false;

  final storage = new FlutterSecureStorage();

  void initNotes(List<FitchMusic> combinedSongList) async {
    // Read all values
    Map<String, String> allValues = await storage.readAll();

    print(allValues);

    print(allValues.keys);

    print(combinedSongList.length);

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
            memo!);
        notes.add(note);
      }
    }

    notifyListeners();
  }

  //local storage 저장 (key : songNum, value : memo)
  //예외 : 이미 있는 노래를 추가할 경우
  Future<void> addNote(String memo) async {
    Note note = Note(
        musicSearchItem.tj_title,
        musicSearchItem.tj_singer,
        musicSearchItem.tj_songNumber,
        musicSearchItem.ky_title,
        musicSearchItem.ky_singer,
        musicSearchItem.ky_songNumber,
        musicSearchItem.gender,
        musicSearchItem.pitch,
        musicSearchItem.pitchNum,
        memo);

    bool flag = false;
    for (Note iter_note in notes) {
      if (iter_note.tj_songNumber == musicSearchItem.tj_songNumber) {
        flag = true;
        break;
      }
    }
    if (!flag) {
      await storage.write(key: musicSearchItem.tj_songNumber, value: memo);
      notes.add(note);
    } else {
      emptyCheck = true;
    }

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
}
