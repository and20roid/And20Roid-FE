class ListDetailInfo {
  final String content;
  final List<String> imageUrls;
  final int participantNum;

  final String appTestLink;
  final String webTestLink;

  final int views;
  final int likes;

  ListDetailInfo({
    required this.content,
    required this.appTestLink,
    required this.webTestLink,
    required this.participantNum,
    required this.imageUrls,
    required this.views,
    required this.likes,
  });

  factory ListDetailInfo.fromJson(Map<String, dynamic> json) {
    return ListDetailInfo(
      participantNum: json['participantNum'],
      imageUrls: List<String>.from(json['imageUrls']),
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      content: 'content',
      appTestLink: 'appTestLink',
      webTestLink: 'webTestLink',
    );
  }
}
