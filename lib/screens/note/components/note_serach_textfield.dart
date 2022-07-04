import 'package:conopot/config/constants.dart';
import 'package:conopot/models/note_data.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class NoteSearchTextfiled extends StatefulWidget {
  const NoteSearchTextfiled({Key? key}) : super(key: key);

  @override
  State<NoteSearchTextfiled> createState() => _NoteSearchTextfiledState();
}

class _NoteSearchTextfiledState extends State<NoteSearchTextfiled> {
  TextEditingController memoController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: Visibility(
        visible:
            Provider.of<NoteData>(context, listen: true).visibleOfTextField,
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: memoController,
                autofocus: true,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      //선택된 곡이 있는 경우
                      if (Provider.of<NoteData>(context, listen: false)
                              .selectedIndex !=
                          -1) {
                        Provider.of<NoteData>(context, listen: false)
                            .addNote(memoController.text);
                        if (Provider.of<NoteData>(context, listen: false)
                                .emptyCheck ==
                            true) {
                          Fluttertoast.showToast(
                              msg: "이미 저장된 노래입니다!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Provider.of<NoteData>(context, listen: false)
                              .initEmptyCheck();
                        } else {
                          Fluttertoast.showToast(
                              msg: "노트가 생성되었습니다.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: kPrimaryColor,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.of(context).pop();
                        }
                      }
                      //아무 곡도 선택되지 않은 경우
                      else {
                        Fluttertoast.showToast(
                            msg: "곡을 선택해주세요",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                  ),
                  border: OutlineInputBorder(),
                  hintText: "이 노래에 대한 나만의 한줄 평",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
