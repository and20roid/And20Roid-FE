import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../model/list_model.dart';
import '../utility/common.dart';

class ListController extends GetxController {
  int lastBoardId = 0;
  RxBool isLoaded = false.obs;
  List<GatherList> gatherListItems = [];

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  Map<String, String> UNIT_ID = kReleaseMode
      ? {
          'ios': '[YOUR iOS AD UNIT ID]',
          'android': 'ca-app-pub-8601392848585629/1080629832',
        }
      : {
          'ios': 'ca-app-pub-3940256099942544/2934735716',
          'android': 'ca-app-pub-3940256099942544/6300978111',
        };

  // Map<String, String> UNIT_ID = {
  //   'ios': '[YOUR iOS AD UNIT ID]',
  //   'android': 'ca-app-pub-8601392848585629/1080629832',
  //   // 'android': 'ca-app-pub-8601392848585629/9554016226',
  // }
  // ;

  ScrollController scrollController = ScrollController();

  void gotoTop() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> requestRecruitingList() async {
    try {
      lastBoardId = 0;
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
          gatherListItems.clear();
          var jsonResults = jsonDecode(utf8.decode(data.bodyBytes));
          var jsonData = jsonResults['readBoardResponses'];
          print(jsonData);

          for (var jsonResult in jsonData) {
            GatherList gatherList = GatherList.fromJson(jsonResult);
            print(jsonResult);
            gatherListItems.add(gatherList);
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

  Future<void> requestDownRecruitingList() async {
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
          print(jsonData);

          List<int> existingIds =
              gatherListItems.map((item) => item.id).toList();
          print(existingIds);
          for (var jsonResult in jsonData) {
            GatherList gatherList = GatherList.fromJson(jsonResult);

            if (!existingIds.contains(gatherList.id)) {
              gatherListItems.add(gatherList);
            }
          }

          //max
          // lastBoardId = existingIds.reduce((value, element) => value > element ? value : element);
          //min
          lastBoardId = existingIds
              .reduce((value, element) => value < element ? value : element);

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
    refreshController.loadComplete();
  }

  @override
  void onInit() {
    requestRecruitingList();
    super.onInit();
  }
}
