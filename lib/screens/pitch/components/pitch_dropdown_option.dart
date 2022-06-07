import 'package:conopot/models/music_search_item_lists.dart';
import 'package:flutter/material.dart';

class DropdownOption extends StatefulWidget {
  DropdownOption({Key? key, required this.musicList}) : super(key: key);
  final MusicSearchItemLists musicList;

  @override
  State<DropdownOption> createState() => _DropdownOptionState(musicList);
}

class _DropdownOptionState extends State<DropdownOption> {
  final MusicSearchItemLists musicList;
  String optionString = '모든 노래';

  _DropdownOptionState(this.musicList);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      alignment: Alignment(0.9, 0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: optionString,
          icon: const Icon(Icons.arrow_drop_down_sharp),
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          onChanged: (String? newValue) {
            musicList.changeSortOption(option: newValue);
            setState(() {
              optionString = newValue!;
            });
          },
          items: <String>['모든 노래', '내 음역대의 노래']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
