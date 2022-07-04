class Note {
  final String tj_title;
  final String tj_singer;
  final String tj_songNumber;
  final String ky_title;
  final String ky_singer;
  String ky_songNumber;
  final String gender;
  final String pitch;
  final int pitchNum;
  final String memo;
  int keyAdjustment;

  Note(
      this.tj_title,
      this.tj_singer,
      this.tj_songNumber,
      this.ky_title,
      this.ky_singer,
      this.ky_songNumber,
      this.gender,
      this.pitch,
      this.pitchNum,
      this.memo,
      this.keyAdjustment);
}
