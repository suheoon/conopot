import 'package:conopot/config/constants.dart';
import 'package:conopot/models/music_search_item_lists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class noteSettingScreen extends StatefulWidget {
  noteSettingScreen({Key? key}) : super(key: key);

  @override
  State<noteSettingScreen> createState() => _noteSettingScreenState();
}

class _noteSettingScreenState extends State<noteSettingScreen> {
  @override
  Widget build(BuildContext context) {
    int choice = Provider.of<MusicSearchItemLists>(context, listen: true)
        .userNoteSetting;
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
              leading: Radio<int>(
                value: 0,
                groupValue: choice,
                onChanged: (int? value) {
                  setState(() {
                    choice = 0;
                    Provider.of<MusicSearchItemLists>(context, listen: false)
                        .changeUserNoteSetting(0);
                  });
                },
              ),
            ),
            Card(
              //color: Color.fromARGB(255, 232, 228, 255),
              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              child: ListTile(
                title: RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                        text: "취중고백",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                    TextSpan(text: " "),
                    TextSpan(
                        text: "김민석",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        )),
                  ],
                )),
                subtitle: Text("요즘 유명한 노래"),
                trailing: Text("80906"),
              ),
            ),
            ListTile(
              title: const Text('노래 최고음 표시'),
              leading: Radio<int>(
                value: 1,
                groupValue: choice,
                onChanged: (int? value) {
                  setState(() {
                    choice = 1;
                    Provider.of<MusicSearchItemLists>(context, listen: false)
                        .changeUserNoteSetting(1);
                  });
                },
              ),
            ),
            Card(
              //color: Color.fromARGB(255, 232, 228, 255),
              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              child: ListTile(
                title: RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                        text: "취중고백",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                    TextSpan(text: " "),
                    TextSpan(
                        text: "김민석",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        )),
                  ],
                )),
                subtitle: Text("요즘 유명한 노래"),
                trailing: Text(
                  "2옥타브 라#",
                  style: TextStyle(color: Color(0xFF7B61FF)),
                ),
              ),
            ),
          ],
        ));
  }
}
