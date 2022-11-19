import 'package:conopot/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PersistentYoutubeVideoPlayer extends StatefulWidget {
  YoutubePlayerController controller;
  PersistentYoutubeVideoPlayer({Key? key, required this.controller}) : super(key: key);

  @override
  State<PersistentYoutubeVideoPlayer> createState() =>
      _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<PersistentYoutubeVideoPlayer> {

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    double screenWidth = SizeConfig.screenWidth;
    return SizedBox(
        width: screenWidth,
        height: defaultSize * 20,
        child: YoutubePlayer(
            aspectRatio: 16 / 8.5,
            controller:
                widget.controller));
  }
}
