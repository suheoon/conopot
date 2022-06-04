import 'package:conopot/models/MusicSearchItemLists.dart';
import 'package:flutter/material.dart';

class FitchCheckBox extends StatefulWidget {
  FitchCheckBox({Key? key, required this.musicList}) : super(key: key);

  final MusicSearchItemLists musicList;

  @override
  State<FitchCheckBox> createState() => _FitchCheckBoxState(musicList);
}

class _FitchCheckBoxState extends State<FitchCheckBox> {
  final MusicSearchItemLists musicList;

  _FitchCheckBoxState(this.musicList);
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
                        musicList.highestFoundItems[index].fitch,
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
