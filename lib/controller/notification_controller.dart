import 'dart:convert';

import 'package:and20roid/model/noti_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../utility/common.dart';

class NotiController extends GetxController {
  RxInt alarmCount = 0.obs;
  List<NotificationList> notiData = [];
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int lastMessageId = 0;

  Future<void> requestUserTestNum() async {
    try {
      int lastMessageId = 0;
      String url = "${Common.url}users/messages";

      String? bearerToken =
          await FirebaseAuth.instance.currentUser!.getIdToken();
      Map<String, dynamic> queryParameters = {
        'lastMessageId': lastMessageId.toString(),
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
          notiData.clear();
          var jsonResults = jsonDecode(utf8.decode(data.bodyBytes));
          var jsonData = jsonResults['fcmMessageResponses'];
          print(
              '------------------fcmMessageResponses Start--------------------, ${jsonData.length}');

          for(var notificationData in jsonData){
            NotificationList notification = NotificationList.fromJson(notificationData);
            notiData.add(notification);

          }
          update();

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

  Future<void> requestDownUserTestNum() async {
    try {
      String url = "${Common.url}users/messages";

      String? bearerToken =
      await FirebaseAuth.instance.currentUser!.getIdToken();
      Map<String, dynamic> queryParameters = {
        'lastMessageId': lastMessageId.toString(),
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
          var jsonData = jsonResults['fcmMessageResponses'];
          print(
              '------------------fcmMessageResponses Start--------------------, ${jsonData.length}');

          List<int> existingIds = notiData.map((item) => item.id).toList();

          for(var notificationData in jsonData){
            NotificationList notification = NotificationList.fromJson(notificationData);

            if (!existingIds.contains(notification.id)) {
              notiData.add(notification);
            }
          }

          lastMessageId = existingIds.reduce((value, element) => value < element ? value : element);
          update();

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
    refreshController.loadComplete();
  }

  @override
  void onInit() {
    requestUserTestNum();
    super.onInit();
  }

}
