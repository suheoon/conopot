import 'package:flutter/cupertino.dart';
import 'note.dart';
import 'music_search_item.dart';

class NoteData extends ChangeNotifier {
  List<Note> notes = [];
  bool visibleOfTextField = false;
  late MusicSearchItem musicSearchItem;

  void addNote(MusicSearchItem musicSearchItem, String memo) {
    final note = Note(
        memo: memo,
        title: musicSearchItem.title,
        singer: musicSearchItem.singer,
        songNumber: musicSearchItem.songNumber);
    notes.add(note);
    notifyListeners();
  }

  void deleteNote(Note note) {
    notes.remove(note);
    notifyListeners();
  }

  void deleteNoteAt(int index) {
    notes.removeAt(index);
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

}
