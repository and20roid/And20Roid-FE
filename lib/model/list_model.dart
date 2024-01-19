class GatherList {
  final int id;
  final String title;
  final int participantNum;
  final int recruitmentNum;
  final String state;
  final String thumbnailUrl;
  final List<String> imageUrls;
  final String introLine;
  final String nickname;
  final String createdDate;
  int views;
  int likes;
  final bool likedBoard;

  GatherList({
    required this.id,
    required this.title,
    required this.participantNum,
    required this.recruitmentNum,
    required this.state,
    required this.thumbnailUrl,
    required this.imageUrls,
    required this.introLine,
    required this.nickname,
    required this.createdDate,
    required this.views,
    required this.likes,
    required this.likedBoard,
  });

  factory GatherList.fromJson(Map<String, dynamic> json) {
    return GatherList(
      id: json['id'],
      title: json['title'],
      participantNum: json['participantNum'],
      recruitmentNum: json['recruitmentNum'],
      state: json['state'],
      thumbnailUrl: json['thumbnailUrl'],
      imageUrls: List<String>.from(json['imageUrls']),
      introLine: json['introLine'],
      nickname: json['nickname'],
      createdDate: json['createdDate'],
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      likedBoard: json['likedBoard'] ?? false,
    );
  }
}
