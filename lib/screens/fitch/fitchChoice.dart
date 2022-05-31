import 'package:flutter/material.dart';

class FitchChoice extends StatelessWidget {
  const FitchChoice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: Text(
          '음역대 측정',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Text('FitchMeasure'),
      ),
    );
  }
}
