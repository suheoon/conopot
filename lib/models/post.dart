import 'dart:convert';
import 'dart:io';

class Post {
  final int postId;
  final int postIconId;
  final String postTitle;
  final String postSubscription;
  int postLikeCount;
  final int? postAuthorId;
  final List<String> postMusicList;
  final String? userName;
  final String? userImage;

  Post(this.postId, this.postIconId, this.postTitle, this.postSubscription,
      this.postLikeCount, this.postAuthorId, this.postMusicList, this.userName, this.userImage);

  // json -> Post변환
  factory Post.fromJson(Map<String, dynamic> json) {
    // String으로 받아온 postMusicList를 파싱하여 String List로 변환
    List<String> songNumberList = [];
    String tmp = "";
    for (int i = 0; i < json['postMusicList'].length; i++) {
      if (json['postMusicList'][i].compareTo("0") >= 0 &&
          (json['postMusicList'][i].compareTo('9') == 0 ||
              json['postMusicList'][i].compareTo('9') == -1)) {
        tmp += json['postMusicList'][i];
      } else {
        if (tmp.isNotEmpty) {
          songNumberList.add(tmp);
          tmp = "";
        }
      }
    }
    String? name = json['username'] ??= 'default';
    String? image = json['userimage'];
    int? postUserId = json['postAuthorId'] ??= 0;

    return Post(
        json['postId'] as int,
        json['postIconId'] as int,
        json['postTitle'] as String,
        json['postSubscription'] == null ? "" : json['postSubscription'] as String,
        json['postLikeCount'] as int,
        postUserId,
        songNumberList,
        name,
        image
    );
  }

  // post -> Json 변환
  Map<String, dynamic> toJson() =>
  {
    'postId' : postId,
    'postIconId' : postIconId,
    'postTitle' : postTitle,
    'postSubscription' : postSubscription,
    'postLikeCount' : postLikeCount,
    'postAuthorID' : postAuthorId,
    'postMusicList' : jsonEncode(postMusicList),
    'username' : userName,
    'userimage' : userImage
  };
  
  @override
  String toString() {
    return '{ ${this.postId}, ${this.postIconId}, ${this.postTitle}, ${this.postSubscription}, ${this.postLikeCount}, ${this.postAuthorId}, ${this.postMusicList}}';
  }
}
