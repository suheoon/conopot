import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/models/youtube_player_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PersistentYoutubeVideoPlayer extends StatefulWidget {
  YoutubePlayerController controller;
  PersistentYoutubeVideoPlayer({Key? key, required this.controller})
      : super(key: key);

  @override
  State<PersistentYoutubeVideoPlayer> createState() =>
      _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<PersistentYoutubeVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    double screenWidth = SizeConfig.screenWidth;
    if (Provider.of<YoutubePlayerState>(context, listen: false).videoList[
            Provider.of<YoutubePlayerState>(context, listen: false)
                .playingIndex] ==
        '없음') {
      if (Provider.of<YoutubePlayerState>(context, listen: false).isMini) {
        return Center(
          child: Text('유튜브 영상이 없습니다 채널톡으로 문의해 주세요.',
              style: TextStyle(color: kPrimaryWhiteColor, fontSize: defaultSize * 0.8)),
        );
      }
      return SizedBox.shrink();
    }
    return SizedBox(
        width: screenWidth,
        height: defaultSize * 20,
        child: YoutubePlayer(
            aspectRatio: 16 / 8.5, controller: widget.controller));
  }
}
