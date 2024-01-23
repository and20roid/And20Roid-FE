class MyListForRequest {
  final int id;
  final String title;
  final int participantNum;
  final int recruitmentNum;
  final String state;
  final String thumbnailUrl;
  final String introLine;
  final String createdDate;
  final bool alreadyInvited;

  MyListForRequest(
      {required this.id,
      required this.title,
      required this.participantNum,
      required this.recruitmentNum,
      required this.state,
      required this.thumbnailUrl,
      required this.introLine,
      required this.createdDate,
      required this.alreadyInvited});

  factory MyListForRequest.fromJson(Map<String, dynamic> json) {
    return MyListForRequest(
        id: json['id'],
        title: json['title'],
        participantNum: json['participantNum'],
        recruitmentNum: json['recruitmentNum'],
        state: json['state'],
        thumbnailUrl: json['thumbnailUrl'],
        introLine: json['introLine'],
        createdDate: json['createdDate'],
        alreadyInvited: json['alreadyInvited']);
  }
}
