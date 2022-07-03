import 'package:flutter/material.dart';

enum NoteMark { tjnum, highestNote, noteDiff }

class noteSettingScreen extends StatefulWidget {
  noteSettingScreen({Key? key}) : super(key: key);

  @override
  State<noteSettingScreen> createState() => _noteSettingScreenState();
}

class _noteSettingScreenState extends State<noteSettingScreen> {
  NoteMark? choice = NoteMark.tjnum;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "애창곡 노트 설정",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context); //뒤로가기
            },
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            ListTile(
              title: const Text('TJ 반주기 번호 표시'),
              leading: Radio<NoteMark>(
                value: NoteMark.tjnum,
                groupValue: choice,
                onChanged: (NoteMark? value) {
                  setState(() {
                    choice = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('노래 최고음 표시'),
              leading: Radio<NoteMark>(
                value: NoteMark.highestNote,
                groupValue: choice,
                onChanged: (NoteMark? value) {
                  setState(() {
                    choice = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('최고음 기반 노래방 키 조정 표시'),
              leading: Radio<NoteMark>(
                value: NoteMark.noteDiff,
                groupValue: choice,
                onChanged: (NoteMark? value) {
                  setState(() {
                    choice = value;
                  });
                },
              ),
            ),
          ],
        ));
  }
}
