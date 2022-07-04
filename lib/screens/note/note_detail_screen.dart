import 'dart:io';

import 'package:conopot/models/note_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/note.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;
  NoteDetailScreen({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  showAlertDialog(BuildContext context) {
    Widget okButton = ElevatedButton(
        onPressed: () {
          Provider.of<NoteData>(context, listen: false).deleteNote(widget.note);
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: Text("노트삭제"));

    Widget cancelButton = ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("취소"));

    AlertDialog alert = AlertDialog(
      content: Text("노트가 삭제 됩니다."),
      actions: [okButton, cancelButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Note> notes = Provider.of<NoteData>(context, listen: false).notes;

    return Scaffold(
      appBar: AppBar(
        title: Text("곡 상세정보"),
        actions: [
          IconButton(
            icon: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
            onPressed: () {
              showAlertDialog(context);
            },
          ),
        ],
      ),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.note.tj_title,
                        overflow: TextOverflow.ellipsis, maxLines: 1),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.note.tj_singer,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 80,
              alignment: Alignment.center,
              child: IconButton(
                  padding: EdgeInsets.only(right: 10),
                  icon: SvgPicture.asset('assets/icons/youtube.svg'),
                  onPressed: () async {
                    final url = Uri.parse(
                        'https://www.youtube.com/results?search_query=${widget.note.tj_title}');
                    if (await canLaunchUrl(url)) {
                      launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  }),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          height: 1,
          child: Divider(
            color: Color(0xFFD2CDCD),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("정보"),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(width: 30, child: Text("TJ")),
                  SizedBox(width: 10),
                  Container(
                    width: 70,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.grey,
                    ),
                    child: Center(child: Text("60398")),
                  ),
                  SizedBox(width: 30),
                  Text("최고음"),
                  SizedBox(width: 10),
                  Container(
                    width: 80,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color(0xFFF54141),
                    ),
                    child: Center(
                      child: Text("2옥타브 라"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(width: 30, child: Text("금영")),
                  SizedBox(width: 10),
                  Container(
                    width: 70,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.grey,
                    ),
                    child: Icon(Icons.search),
                  ),
                  SizedBox(width: 30),
                  Text("키조정"),
                  SizedBox(width: 10),
                  Container(
                    width: 80,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color(0xFFF54141),
                    ),
                    child: Center(
                      child: Text("2옥타브 라"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("메모"),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: Align(
                      alignment: Alignment(-0.9, 0),
                      child: Text(widget.note.memo),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color(0xFFF5F5FA)),
                  )
                ],
              ),
              SizedBox(height: 30),
              Text("노래 추천"),
            ],
          ),
        ),
      ]),
    );
  }
}
