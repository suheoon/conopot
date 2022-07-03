import 'package:conopot/models/note_data.dart';
import 'package:flutter/material.dart';
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
                      Provider.of<NoteData>(context, listen: false).addNote(
                        Provider.of<NoteData>(context, listen: false)
                            .musicSearchItem,
                        memoController.text,
                      );
                      Navigator.of(context).pop();
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
