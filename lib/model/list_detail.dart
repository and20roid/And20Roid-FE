class ListDetailInfo {
  final String content;
  late final List<String> imageUrls;
  final int participantNum;
  final String appTestLink;
  final String webTestLink;
  final String nickName;
  final int views;
  final int likes;
  final bool likedBoard;

  ListDetailInfo({
    required this.content,
    required this.appTestLink,
    required this.webTestLink,
    required this.participantNum,
    required this.imageUrls,
    required this.nickName,
    required this.views,
    required this.likes,
    required this.likedBoard,
  });

  factory ListDetailInfo.fromJson(Map<String, dynamic> json) {
    return ListDetailInfo(
        participantNum: json['participantNum'],
        imageUrls: List<String>.from(json['imageUrls']),
        views: json['views'],
        likes: json['likes'],
        content: json['content'],
        appTestLink: json['appTestLink'],
        webTestLink: json['webTestLink'],
        nickName: json['nickname'],
        likedBoard: json['likedBoard']);
  }
}
