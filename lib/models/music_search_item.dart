class MusicSearchItem {
  final String title;
  final String singer;
  final String songNumber;

  final String search_keyword_title_singer;
  final String search_keyword_singer_title;

  bool isTouching = false;

  MusicSearchItem(
      {required this.title,
      required this.singer,
      required this.songNumber,
      required this.search_keyword_title_singer,
      required this.search_keyword_singer_title});
}
