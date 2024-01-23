import 'dart:convert';

import 'package:and20roid/model/noti_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../utility/common.dart';

class NotiController extends GetxController {
  RxInt alarmCount = 0.obs;
  List<NotificationList> notiData = [];
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future<void> requestUserTestNum() async {
    try {
      String url = "${Common.url}users/messages";

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
          var jsonData = jsonResults['fcmMessageResponses'];
          print(
              '------------------fcmMessageResponses Start--------------------, ${jsonData.length}');
          for (int i = 0; i < jsonData.length; i++) {
            print(jsonData[i]);
            notiData.add(NotificationList.fromJson(jsonData[i]));
          }
          print(
              '------------------fcmMessageResponses End--------------------');
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
    requestUserTestNum();
    super.onInit();
  }
}
