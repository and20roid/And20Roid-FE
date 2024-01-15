class UserTestInfo {
  final int completedTestCount;
  final int uploadBoardCount;

  UserTestInfo({required this.completedTestCount, required this.uploadBoardCount});

  factory UserTestInfo.fromJson(Map<String, dynamic> json) {
    return UserTestInfo(
        completedTestCount: json['completedTestCount'],
        uploadBoardCount: json['uploadBoardCount']);
  }
}
