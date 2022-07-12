import 'package:conopot/models/music_search_item_lists.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final MusicSearchItemLists musicList;

  const SearchBar({required this.musicList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        onChanged: (text) => {
          musicList.runFilter(text, musicList.tabIndex),
        },
        enableInteractiveSelection: false,
        focusNode: FocusNode(),
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
    );
  }
}
