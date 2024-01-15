class Rank {
  final int userId;
  final int rank;
  final String nickname;
  final int completedTestCount;

  Rank(
      {required this.userId, required this.rank, required this.nickname, required this.completedTestCount});

  factory Rank.fromJson(Map<String, dynamic>json){
    return Rank(userId: json["userId"],
        rank: json["rank"],
        nickname: json["nickname"],
        completedTestCount: json["completedTestCount"]);
  }
}