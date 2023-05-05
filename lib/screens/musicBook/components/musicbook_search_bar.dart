import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/global/debounce.dart';
import 'package:conopot/models/music_state.dart';
import 'package:conopot/models/note_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  final MusicState musicList;
  SearchBar({required this.musicList});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String _dropdwonValue = "제목";
  final Debounce _debounce = Debounce(delay: Duration(milliseconds: 500));

  @override
  void initState() {
    Provider.of<NoteState>(context, listen: false).controller =
        TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _clearTextField() {
      Provider.of<NoteState>(context, listen: false).controller.text = "";
      widget.musicList.runFilter(
          Provider.of<NoteState>(context, listen: false).controller.text,
          widget.musicList.tabIndex,
          _dropdwonValue);
    }

    double defaultSize = SizeConfig.defaultSize;
    return Container(
      margin: EdgeInsets.fromLTRB(
          defaultSize, defaultSize * 1.5, defaultSize, defaultSize),
      decoration: BoxDecoration(
        color: kPrimaryLightBlackColor,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Row(
        children: [
          SizedBox(width: defaultSize * 1.5),
          DropdownButton(
            items: [
              DropdownMenuItem(child: Text("제목"), value: "제목"),
              DropdownMenuItem(child: Text("가수"), value: "가수"),
              DropdownMenuItem(child: Text("번호"), value: "번호"),
            ],
            value: _dropdwonValue,
            iconEnabledColor: kMainColor,
            dropdownColor: kPrimaryBlackColor,
            underline: SizedBox(),
            style: TextStyle(color: kPrimaryWhiteColor),
            onChanged: (String? selectedValue) {
              if (selectedValue is String) {
                _clearTextField();
                setState(() {
                  _dropdwonValue = selectedValue;
                });
              }
            },
          ),
          SizedBox(width: defaultSize),
          Expanded(
            child: TextField(
              controller:
                  Provider.of<NoteState>(context, listen: false).controller,
              style: TextStyle(color: kPrimaryWhiteColor),
              onChanged: (text) => {
                if (_dropdwonValue != '가사')
                  {
                    _debounce.call(() {
                      widget.musicList.runFilter(
                          text, widget.musicList.tabIndex, _dropdwonValue);
                    })
                  }
              },
              onSubmitted: (text) => {
                widget.musicList
                    .runFilter(text, widget.musicList.tabIndex, _dropdwonValue)
              },
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.name,
              cursorColor: kMainColor,
              decoration: InputDecoration(
                hintText: (_dropdwonValue == '제목')
                    ? '제목 검색'
                    : (_dropdwonValue == '가수')
                        ? '가수 검색'
                        : (_dropdwonValue == '번호')
                            ? '번호 검색'
                            : (_dropdwonValue == '가사')
                                ? '가사 검색'
                                : '',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: defaultSize * 1.5,
                  color: kPrimaryLightGreyColor,
                ),
                border: InputBorder.none,
                suffixIcon: Provider.of<NoteState>(context, listen: false)
                        .controller
                        .text
                        .isEmpty
                    ? Icon(
                        Icons.search,
                        color: kPrimaryWhiteColor,
                      )
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearTextField,
                        color: kPrimaryWhiteColor,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
