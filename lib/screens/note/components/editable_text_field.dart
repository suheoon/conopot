import 'package:conopot/config/constants.dart';
import 'package:conopot/config/size_config.dart';
import 'package:conopot/models/note_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../models/note.dart';

class EditableTextField extends StatefulWidget {
  late Note note;
  EditableTextField({Key? key, required Note this.note}) : super(key: key);

  @override
  State<EditableTextField> createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  bool _isEditingText = false;
  late TextEditingController _editingController;
  late String initialText = widget.note.memo;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _editableTextField();
  }

  Widget _editableTextField() {
    if (_isEditingText) {
      return Center(
        child: TextField(
          autofocus: true,
          controller: _editingController,
          maxLength: 25,
          decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: TextButton(
                child: Text(
                  "저장",
                  style: TextStyle(color: kTitleColor),
                ),
                onPressed: () {
                  //!event: 곡 상세정보 뷰 - 메모 수정
                  Provider.of<NoteData>(context, listen: false)
                      .songMemoEditEvent(widget.note.tj_title);
                  setState(() {
                    initialText = _editingController.text;
                    _isEditingText = false;
                    Provider.of<NoteData>(context, listen: false)
                        .editNote(widget.note, initialText);
                  });
                },
              )),
        ),
      );
    }
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isEditingText = true;
            });
          },
          child: SizedBox(
            width: SizeConfig.screenWidth * 0.7,
            child: Text(
              initialText.length == 0 ? "메모를 입력해 주세요" : initialText,
              overflow: TextOverflow.ellipsis,
              style: initialText.length == 0 ? TextStyle(
                color: Colors.grey[600],
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ) :TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () {
              setState(() {
                _isEditingText = true;
              });
            },
            icon: Icon(Icons.edit),
          ),
        )
      ],
    );
  }
}
