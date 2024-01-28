class MyUploadTest {
  final int id;
  final String title;
  final int participantNum;
  final int recruitmentNum;
  final String state;
  final String thumbnailUrl;
  final String createdDate;
  final String introLine;
  bool deleted;

  MyUploadTest({
    required this.id,
    required this.title,
    required this.participantNum,
    required this.recruitmentNum,
    required this.state,
    required this.thumbnailUrl,
    required this.createdDate,
    required this.introLine,
    this.deleted = false,
  });

  factory MyUploadTest.fromJson(Map<String, dynamic> json) {
    return MyUploadTest(
      id: json['id'],
      title: json['title'],
      participantNum: json['participantNum'],
      recruitmentNum: json['recruitmentNum'],
      state: json['state'],
      thumbnailUrl: json['thumbnailUrl'],
      createdDate: json['createdDate'],
      introLine: json['introLine'],
    );
  }

  factory MyUploadTest.fromJsonD(Map<String, dynamic> json) {
    return MyUploadTest(
        id: json['id'],
        title: json['title'],
        participantNum: json['participantNum'],
        recruitmentNum: json['recruitmentNum'],
        state: json['state'],
        thumbnailUrl: json['thumbnailUrl'],
        createdDate: json['createdDate'],
        introLine: json['introLine'],
        deleted: json['deleted']);
  }
}
