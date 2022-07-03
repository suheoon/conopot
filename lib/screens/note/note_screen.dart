import 'package:carousel_slider/carousel_slider.dart';
import 'package:conopot/models/note_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../models/note.dart';
import 'add_note_screen.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  // Widget _CarouselSlider() {
  //   return CarouselSlider(options: CarouselOptions,items: [],)
  // }

  Widget _ReorderListView() {
    return Container(
      child: Consumer<NoteData>(
        builder: (context, noteData, child) {
          return ReorderableListView(
            children: noteData.notes
                .map(
                  (note) => Card(
                    key: Key(
                      '${noteData.notes.indexOf(note)}',
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Slidable(
                      key: Key(
                        '${noteData.notes.indexOf(note)}',
                      ),
                      endActionPane: ActionPane(
                          extentRatio: .20,
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (BuildContext context) {
                                noteData.deleteNote(note);
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                            ),
                          ]),
                      child: ListTile(
                        title: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: note.title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  )),
                              TextSpan(text: " "),
                              TextSpan(
                                  text: note.singer,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  )),
                            ],
                          ),
                        ),
                        subtitle: Text(note.memo),
                        trailing: Text(note.songNumber),
                      ),
                    ),
                  ),
                )
                .toList(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final Note note = noteData.notes.removeAt(oldIndex);
                noteData.notes.insert(newIndex, note);
              });
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "애창곡 노트",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 5.0,
        child: SvgPicture.asset('assets/icons/addButton.svg'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddNoteScreen()),
          );
        },
      ),
      body: _ReorderListView(),
    );
  }
}
