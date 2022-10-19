import 'dart:convert';

import 'package:conopot/config/constants.dart';
import 'package:conopot/config/size_config.dart';
import 'package:conopot/models/note_data.dart';
import 'package:conopot/screens/feed/components/post_list.dart';
import 'package:conopot/screens/feed/feed_creation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedScrrenController {
  late int lastPostId;
  late void Function(int lastPostId) loadMore;
}

class FeedScreen extends StatefulWidget {
  FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late ScrollController _controller;
  final FeedScrrenController feedScrrenController = FeedScrrenController();
  
  @override
  void initState() {
    _controller = ScrollController()
      ..addListener(() {
        if (_controller.position.maxScrollExtent ==
            _controller.position.pixels) {
          feedScrrenController.loadMore(feedScrrenController.lastPostId);
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      appBar: AppBar(
        title: Text("피드"),
        centerTitle: false,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Provider.of<NoteData>(context, listen: false).lists = [];
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => CreateFeedScreen()));
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(
              defaultSize, defaultSize * 0.5, defaultSize, defaultSize * 0.5),
          decoration: BoxDecoration(
              color: kMainColor,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: IntrinsicWidth(
            child: Row(
              children: [
                Icon(Icons.library_music, color: kPrimaryWhiteColor),
                SizedBox(width: defaultSize),
                Text(
                  "내 플레이리스트 자랑하기",
                  style: TextStyle(
                      color: kPrimaryWhiteColor,
                      fontSize: defaultSize * 1.3,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          controller: _controller,
          children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: defaultSize),
            height: defaultSize * 9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "배너광고?",
                  style: TextStyle(color: kPrimaryWhiteColor),
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: kPrimaryLightBlackColor,
                borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
          SizedBox(height: defaultSize),
          Container(
            padding: EdgeInsets.fromLTRB(
                defaultSize  , defaultSize * 1.5, defaultSize , defaultSize *1.5),
            margin: EdgeInsets.all(defaultSize),
            decoration: BoxDecoration(
                color: kPrimaryLightBlackColor.withOpacity(0.8),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                "🎤 싱스타그램",
                style: TextStyle(color: kMainColor, fontSize: defaultSize * 1.4, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: defaultSize * 0.5),
              Text(
                "다른 사람들은 노래방에서 어떤 노래를 부를까?",
                style: TextStyle(color: kPrimaryWhiteColor, fontSize: defaultSize * 1.5, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: defaultSize * 0.5),
              Text(
                "궁금할 땐 싱스타그램에서 찾아보고 내 플레이리스트도 자랑해보세요!",
                style: TextStyle(color: kPrimaryLightGreyColor, fontSize: defaultSize * 1.3),
              ),
            ]),
          ),
          SizedBox(height: defaultSize),
          PostListView(controller: feedScrrenController)
        ]),
      ),
    );
  }
}
