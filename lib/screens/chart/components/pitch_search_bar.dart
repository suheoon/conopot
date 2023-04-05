import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/global/debounce.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/models/music_state.dart';
import 'package:flutter/material.dart';

class PitchSearchBar extends StatefulWidget {
  final MusicState musicList;
  PitchSearchBar({required this.musicList});

  @override
  State<PitchSearchBar> createState() => _PitchSearchBarState();
}

class _PitchSearchBarState extends State<PitchSearchBar> {
  TextEditingController _controller = TextEditingController();
  double defaultSize = SizeConfig.defaultSize;
  final Debounce _debounce = Debounce(delay: Duration(milliseconds: 500));

  void _clearTextField() {
    _controller.text = "";
    widget.musicList.runHighFitchFilter(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryLightBlackColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: TextField(
        style: TextStyle(color: kPrimaryWhiteColor),
        controller: _controller,
        onChanged: (text) => {
          _debounce.call(() {
            widget.musicList.runHighFitchFilter(text);
          })
        },
        enableInteractiveSelection: false,
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.name,
        cursorColor: kMainColor,
        decoration: InputDecoration(
          hintText: '노래, 가수 검색',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: defaultSize * 1.5,
            color: kPrimaryLightGreyColor,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: kPrimaryWhiteColor,
          ),
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _clearTextField();
                    widget.musicList.initCombinedBook();
                  },
                  color: kPrimaryWhiteColor,
                ),
        ),
      ),
    );
  }
}
