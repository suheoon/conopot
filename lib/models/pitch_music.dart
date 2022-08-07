class FitchMusic {
  final String tj_title;
  final String tj_singer;
  final String tj_songNumber;
  final String ky_title;
  final String ky_singer;
  final String ky_songNumber;
  final String gender;
  final int pitchNum;

  final String search_keyword_title_singer;
  final String search_keyword_singer_title;

  FitchMusic(
      {required this.tj_title,
      required this.tj_singer,
      required this.tj_songNumber,
      required this.ky_title,
      required this.ky_singer,
      required this.ky_songNumber,
      required this.gender,
      required this.pitchNum,
      required this.search_keyword_title_singer,
      required this.search_keyword_singer_title});
}
