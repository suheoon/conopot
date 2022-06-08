import 'package:conopot/models/music_search_item_lists.dart';
import 'package:flutter/material.dart';

class PitchCheckBox extends StatefulWidget {
  PitchCheckBox({Key? key, required this.musicList}) : super(key: key);

  final MusicSearchItemLists musicList;

  @override
  State<PitchCheckBox> createState() => _PitchCheckBoxState(musicList);
}

class _PitchCheckBoxState extends State<PitchCheckBox> {
  final MusicSearchItemLists musicList;

  _PitchCheckBoxState(this.musicList);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: musicList.highestFoundItems.isNotEmpty
          ? ListView.builder(
              itemCount: musicList.highestFoundItems.length,
              itemBuilder: (context, index) => Card(
                color: Colors.white,
                elevation: 1,
                child: CheckboxListTile(
                  title: Text(musicList.highestFoundItems[index].tj_title),
                  subtitle: Text(musicList.highestFoundItems[index].tj_singer),
                  secondary: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        musicList.highestFoundItems[index].pitch,
                        style: TextStyle(
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  value: musicList.isChecked[index],
                  onChanged: (bool? value) {
                    setState(() {
                      musicList.isChecked[index] = value!;
                      if (value == true) {
                        musicList.checkedMusics
                            .add(musicList.highestFoundItems[index]);
                      } else {
                        musicList.checkedMusics
                            .remove(musicList.highestFoundItems[index]);
                      }
                    });
                  },
                ),
              ),
            )
          : Text(
              '검색 결과가 없습니다',
              style: TextStyle(fontSize: 18),
            ),
    );
  }
}
