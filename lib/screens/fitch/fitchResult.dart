import 'package:conopot/constants.dart';
import 'package:conopot/screens/chart/chart_screen.dart';
import 'package:flutter/material.dart';

class FitchResult extends StatelessWidget {
  final int pitchLevel;

  const FitchResult({super.key, required this.pitchLevel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: Text(
          '측정 결과',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Text(
            '내 최고음 구간',
            style: TextStyle(
              color: kTextLightColor,
              fontSize: 15,
            ),
          ),
          RangeSlider(
            values: RangeValues(pitchLevel - 2, pitchLevel.toDouble()),
            max: 21,
            min: -5,
            divisions: 4,
            labels: RangeLabels(
              RangeValues(pitchLevel - 2, pitchLevel.toDouble())
                  .start
                  .round()
                  .toString(),
              RangeValues(pitchLevel - 2, pitchLevel.toDouble())
                  .end
                  .round()
                  .toString(),
            ),
            onChanged: (RangeValues values) {},
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChartScreen(),
                ),
              );
            },
            child: Text('나에게 맞는 노래 찾으러 가기'),
          ),
        ],
      ),
    );
  }
}
