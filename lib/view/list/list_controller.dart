import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../model/list_model.dart';
import '../../utility/common.dart';

class ListController extends GetxController {
  int lastBoardId = 0;
  final List<GatherList> gatherListItems = [];
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future<void> requestRecruitingList() async {
    try {
      String url = "${Common.url}boards";
      String? bearerToken =
          await FirebaseAuth.instance.currentUser!.getIdToken();
      Map<String, dynamic> queryParameters = {
        'lastBoardId': lastBoardId.toString(),
      };
      var data = await http.get(
        Uri.parse(url).replace(queryParameters: queryParameters),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $bearerToken',
        },
      );

      if (data.statusCode == 200) {
        if (data.body.isNotEmpty) {
          var jsonResults = jsonDecode(utf8.decode(data.bodyBytes));

          var jsonData = jsonResults['readBoardResponses'];
          for (var jsonResult in jsonData) {
            GatherList gatherList = GatherList.fromJson(jsonResult);
            gatherListItems.add(gatherList);
          }

          if (gatherListItems.length >= 10) {
            lastBoardId += 10;
          }
          print('$lastBoardId 번 째 게시글을 가져옴');
          update();
        }
      } else {
        print("Status code: ${data.statusCode}");
        print("Response body: ${data.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
    refreshController.refreshCompleted();
  }

  @override
  void onInit() {
    requestRecruitingList();
    super.onInit();
  }
}
