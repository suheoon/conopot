import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MusicSearchItem {
  final String title;
  final String singer;
  final String songNumber;

  MusicSearchItem(
      {required this.title, required this.singer, required this.songNumber});
}
