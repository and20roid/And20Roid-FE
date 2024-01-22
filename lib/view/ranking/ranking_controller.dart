import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../model/ranking_model.dart';
import '../../utility/common.dart';

class RankingController extends GetxController{
  List<Rank> rankList = [];

  Future<void> requestTotalRanking() async {
    try {
      String url = "${Common.url}participation/ranking";
      String? bearerToken =
      await FirebaseAuth.instance.currentUser!.getIdToken();

      var data = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $bearerToken',
        },
      );

      if (data.statusCode == 200) {
        if (data.body.isNotEmpty) {
          var jsonResults = jsonDecode(utf8.decode(data.bodyBytes));
          var jsonData = jsonResults['rankInfos'];
          for (var jsonResult in jsonData) {
            print("ranking : $jsonResult");
            Rank ranking = Rank.fromJson(jsonResult);
            rankList.add(ranking);
          }
        }
      } else {
        print("Status code: ${data.statusCode}");
        print("Response body: ${data.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void onInit() {
    requestTotalRanking();
    super.onInit();
  }

}
