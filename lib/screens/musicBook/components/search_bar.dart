import 'package:conopot/models/music_search_item_lists.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final MusicSearchItemLists musicList;
  SearchBar({required this.musicList});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  void _clearTextField() {
    _controller.text = "";
    widget.musicList.runFilter(_controller.text, widget.musicList.tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: _controller,
        onChanged: (text) => {
          widget.musicList.runFilter(text, widget.musicList.tabIndex),
        },
        enableInteractiveSelection: false,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: '노래 제목 또는 가수명을 입력해주세요',
          contentPadding: EdgeInsets.all(15),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 0.1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 0.1),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearTextField,
                  color: Colors.grey,
                ),
        ),
      ),
    );
  }
}
