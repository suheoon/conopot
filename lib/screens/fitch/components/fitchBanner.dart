import 'package:conopot/models/FitchItem.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class FitchBanner extends StatelessWidget {
  final FitchItem fitchItem;
  const FitchBanner({
    Key? key,
    required this.fitchItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: DefaultTextStyle(
          style: TextStyle(color: Colors.black, fontSize: 20.0),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              Center(
                child: Column(children: [
                  Text(fitchItem.fitchName),
                  Text(fitchItem.fitchCode),
                  Text(fitchItem.fitchContext),
                  TextButton(
                    onPressed: () {
                      play(fitchItem.fitchCode);
                    },
                    child: Icon(Icons.play_arrow),
                  ),
                  TextButton(
                    onPressed: () {
                      //local storage? or 최종결과 page route
                    },
                    child: Text('여기까지가 끝인가보오..'),
                  ),
                ]),
              )
            ],
          )),
    );
  }
}

void play(String fitch) async {
  final player = AudioCache(prefix: 'assets/fitches/');
  await player.play('$fitch.mp3');
}
