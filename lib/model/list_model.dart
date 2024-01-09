class GatherList {
  final String imageUrl;
  final String title;
  final String auth;
  final int currentTester;
  final int date;

  GatherList(
      this.imageUrl, this.title, this.auth, this.currentTester, this.date);

  GatherList.fromJson(Map<String, dynamic> json)
      : imageUrl = json['imgUrl'],
        title = json['title'],
        auth = json['auth'],
        currentTester = json['currentTester'],
        date = json['date'];
}
