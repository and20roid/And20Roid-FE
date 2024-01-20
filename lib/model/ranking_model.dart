class Rank {
  final int userId;
  final int rank;
  final String nickname;
  final int completedTestCount;
  final int interactionCountAsTester;
  final int interactionCountAsUploader;
  final bool relatedUser;

  Rank({
    required this.userId,
    required this.rank,
    required this.nickname,
    required this.completedTestCount,
    required this.interactionCountAsTester,
    required this.interactionCountAsUploader,
    required this.relatedUser,
  });

  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(
        userId: json["userId"],
        rank: json["rank"],
        nickname: json["nickname"],
        completedTestCount: json["completedTestCount"],
        interactionCountAsTester: json['interactionCountAsTester'],
        interactionCountAsUploader: json['interactionCountAsUploader'],
        relatedUser: json['relatedUser']);
  }
}
