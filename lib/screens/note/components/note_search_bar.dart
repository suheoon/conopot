import 'package:conopot/models/music_search_item_lists.dart';
import 'package:conopot/models/note_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteSearchBar extends StatelessWidget {
  final MusicSearchItemLists musicList;

  const NoteSearchBar({required this.musicList});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(
      builder: (context, noteData, child) => Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: TextField(
          onChanged: (text) => {
            musicList.runCombinedFilter(text),
          },
          onTap: () {
            noteData.setSelectedIndex(-1);
            noteData.hideTextFiled();
          },
          enableInteractiveSelection: false,
          textAlign: TextAlign.left,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            hintText: '노래 제목 또는 가수명을 입력해주세요',
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 0.1),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 0.1),
            ),
          ),
        ),
      ),
    );
  }
}
