class GatherList {
  final int id;
  final String title;
  final int participantNum;
  final int recruitmentNum;
  final String state;
  final String thumbnailUrl;
  final String nickname;
  final String createdDate;

  GatherList({
    required this.id,
    required this.title,
    required this.participantNum,
    required this.recruitmentNum,
    required this.state,
    required this.thumbnailUrl,
    required this.nickname,
    required this.createdDate,
  });

  factory GatherList.fromJson(Map<String, dynamic> json) {
    return GatherList(
      id: json['id'],
      title: json['title'],
      participantNum: json['participantNum'],
      recruitmentNum: json['recruitmentNum'],
      state: json['state'],
      thumbnailUrl: json['thumbnailUrl'],
      nickname: json['nickname'],
      createdDate: json['createdDate'],
    );
  }
}
