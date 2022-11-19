import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'note.dart';

class YoutubePlayerProvider extends ChangeNotifier {
  // 타이머 init 하는걸 main에서 호출
  bool isHome = false;
  bool isMini = true;
  bool isPlaying = false;
  int playingIndex = 0;
  List<String> videoList = [];
  late Function refresh;

  YoutubePlayerController controller = YoutubePlayerController();

  void youtubeInit(List<Note> notes, Map<String, String> youtubeURL) {
    videoList = [];
    for (var note in notes) {
      videoList.add(youtubeURL[note.tj_songNumber]!);
    }

    controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: false,
        loop: true,
      ),
    )..onInit = () async {
        await controller.cueVideoById(videoId: videoList[0]);
      };
  }

  void load() {
    playingIndex = 0;
    notifyListeners();
  }

  void removeAllVideoList() {
    playingIndex = 0;
    videoList = [];
    notifyListeners();
  }

  void addVideoId(Note note, Map<String, String> youtubeURL) {
    videoList.add(youtubeURL[note.tj_songNumber]!);
    notifyListeners();
  }

  String getThumbnail() {
    if (videoList.isNotEmpty)
      return YoutubePlayerController.getThumbnail(
          videoId: videoList[playingIndex]);
    else
      return "";
  }

  void rebuild() {
    refresh();
  }

  void openPlayer() {
    isHome = true;
  }

  void closePlayer() {
    isHome = false;
  }

  void stopVideo() async {
    await controller.pauseVideo();
    isPlaying = false;
    notifyListeners();
  }

  void playVideo() async {
    await controller.playVideo();
    isPlaying = true;
    notifyListeners();
  }

  void previousVideo() {
    if (playingIndex - 1 >= 0) playingIndex -= 1;
    controller.cueVideoById(videoId: videoList[playingIndex]);
    isPlaying = true;
    refresh();
    notifyListeners();
  }

  void nextVideo() {
    if (videoList.length > playingIndex + 1) playingIndex += 1;
    controller.cueVideoById(videoId: videoList[playingIndex]);
    isPlaying = true;
    refresh();
    notifyListeners();
  }

  void enterNoteDetailScreen(int index) {
    isMini = false;
    notifyListeners();
  }

  void leaveNoteDetailScreen() async {
    isMini = true;
    notifyListeners();
    var state = await controller.playerState;
    if (state == PlayerState.playing) {
      isPlaying = true;
    }
    notifyListeners();
  }

  void playMiniPlayer() {
    isPlaying = true;
    notifyListeners();
  }

  void changePlayingIndex(int index) async {
    if (playingIndex != index) {
      playingIndex = index;
      controller.cueVideoById(videoId: videoList[playingIndex]);
      refresh();
      notifyListeners();
    }
  }

  void downPlayingIndex() {
    if (playingIndex - 1 >= 0) {
      playingIndex -= 1;
    }
    notifyListeners();
  }
}
