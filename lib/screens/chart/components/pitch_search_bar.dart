import 'package:conopot/models/music_search_item_lists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PitchSearchBar extends StatefulWidget {
  final MusicSearchItemLists musicList;
  PitchSearchBar({required this.musicList});

  @override
  State<PitchSearchBar> createState() => _PitchSearchBarState();
}

class _PitchSearchBarState extends State<PitchSearchBar> {

  TextEditingController _controller = TextEditingController();

  void _clearTextField() {
    _controller.text = "";
    widget.musicList.runHighFitchFilter(_controller.text);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: TextField(
        controller: _controller,
        onChanged: (text) => {
          widget.musicList.runHighFitchFilter(text),
        },
        textAlign: TextAlign.left,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: '제목 및 가수명을 입력하세요',
          contentPadding: EdgeInsets.all(0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            borderSide: BorderSide(
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          suffixIcon: _controller.text.isEmpty
                  ? null // Show nothing if the text field is empty
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
