class NotificationList {
  final int id;
  final String title;
  final String content;
  final String reqDate;
  final bool successYn;
  final String type;
  final int boardId;
  final String thumbnailUrl;
  final String boardTitle;
  final String introLine;
  final String appTestLink;
  final String webTestLink;

  NotificationList({
    required this.id,
    required this.title,
    required this.content,
    required this.reqDate,
    required this.successYn,
    required this.type,
    required this.boardId,
    required this.thumbnailUrl,
    required this.boardTitle,
    required this.introLine,
    required this.appTestLink,
    required this.webTestLink,
  });

  factory NotificationList.fromJson(Map<String, dynamic> json) {
    return NotificationList(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      reqDate: json['reqDate'] ?? '',
      successYn: json['successYn'] ?? false,
      type: json['type'] ?? '',
      boardId: json['boardId'] ?? 0,
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      boardTitle: json['boardTitle'] ?? '',
      introLine: json['introLine'] ?? '',
      appTestLink: json['appTestLink'] ?? '',
      webTestLink: json['webTestLink'] ?? '',
    );
  }
}
