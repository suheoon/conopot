import 'package:conopot/models/MusicSearchItemLists.dart';
import 'package:flutter/material.dart';

class FitchSearchBar extends StatelessWidget {
  final MusicSearchItemLists musicList;

  const FitchSearchBar({required this.musicList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: TextField(
        onChanged: (text) => {
          musicList.runHighFitchFilter(text),
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: '제목 및 가수명을 검색하세요',
          contentPadding: EdgeInsets.all(0),
          suffixIcon: Icon(Icons.search),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            borderSide: BorderSide(
              width: 1,
              color: Color(0xFF7B61FF),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
        ),
      ),
    );
  }
}
