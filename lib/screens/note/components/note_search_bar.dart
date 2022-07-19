import 'package:conopot/models/music_search_item_lists.dart';
import 'package:conopot/models/note_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteSearchBar extends StatefulWidget {
  final MusicSearchItemLists musicList;
  NoteSearchBar({required this.musicList});

  @override
  State<NoteSearchBar> createState() => _NoteSearchBarState();
}

class _NoteSearchBarState extends State<NoteSearchBar> {
  final TextEditingController _controller = TextEditingController();
  

  void _clearTextField() {
    _controller.text = "";
    widget.musicList.runCombinedFilter(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: _controller,
        onChanged: (text) => {widget.musicList.runCombinedFilter(text)},
        onTap: () {
          Provider.of<NoteData>(context, listen: false).setSelectedIndex(-1);
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
                  onPressed: (){
                    _clearTextField();
                    widget.musicList.initCombinedBook();
                  },
                  color: Colors.grey,
                ),
        ),
      ),
    );
  }
}
