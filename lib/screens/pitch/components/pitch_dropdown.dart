import 'package:conopot/models/music_search_item_lists.dart';
import 'package:flutter/material.dart';

class PitchDropdown extends StatelessWidget {
  final MusicSearchItemLists musicList;

  const PitchDropdown({super.key, required this.musicList});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      alignment: Alignment(0.9, 0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: '높은 음정순',
          icon: const Icon(Icons.arrow_drop_down_sharp),
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          onChanged: (String? newValue) {
            musicList.changeSortOption(option: newValue);
          },
          items: <String>['높은 음정순', '낮은 음정순']
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
