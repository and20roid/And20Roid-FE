class UserTestInfo {
  final int completedTestCount;
  final int uploadBoardCount;
  final int rank;
  final String nickname;
  final int interactionCounts;

  UserTestInfo({
    required this.completedTestCount,
    required this.uploadBoardCount,
    required this.rank,
    required this.nickname,
    required this.interactionCounts,
  });

  factory UserTestInfo.fromJson(Map<String, dynamic> json) {
    return UserTestInfo(
      completedTestCount: json['completedTestCount'],
      uploadBoardCount: json['uploadBoardCount'],
      rank: json['rank'] ?? 0,
      nickname: json['nickname'],
      interactionCounts: json['interactionCounts'] ?? 0,
    );
  }
}
