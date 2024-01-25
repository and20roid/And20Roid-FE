import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../model/mypage_tests.dart';
import '../../utility/common.dart';

class MyPageControllrer extends GetxController{
  final SaveSharedPreferences sharedPreferences = SaveSharedPreferences();
  final RefreshController refreshController1 =
  RefreshController(initialRefresh: false);
  final RefreshController refreshController2 =
  RefreshController(initialRefresh: false);

  String? name;
  String? profileUrl;
  int lastBoardId = 0;
  int partilastBoardId = 0;
  int completedTestCount = 0;
  int uploadBoardCount = 0;
  int rank = 0;

  List<MyUploadTest> myUploadTest = [];
  List<MyUploadTest> myPartiTest = [];

  Future<void> getUserName() async {
    name = await sharedPreferences.getUserNick();
    profileUrl = await sharedPreferences.getUserProfile();
    await requestMyUploadTest();
    await requestMyParticipantTest();
    await requestMyInfo();
    update();
  }

  Future<void> requestMyInfo() async {
    try {
      String url = "${Common.url}users";
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
          print(jsonResults);
          name = jsonResults['nickname'];
          completedTestCount = jsonResults['completedTestCount'];
          uploadBoardCount = jsonResults['uploadBoardCount'];
          rank = jsonResults['rank'];
        }
      } else {
        print("Status code: ${data.statusCode}");
        print("Response body: ${data.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> requestMyUploadTest() async {
    try {
      String url = "${Common.url}myPages/boards/upload";
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
          myUploadTest.clear();
          for (var jsonResult in jsonData) {
            print(jsonResult);
            MyUploadTest gather = MyUploadTest.fromJson(jsonResult);
            print(
                '----------------------------업로드한 테스트 ------------------------');

            myUploadTest.add(gather);
          }
        }
        if (myUploadTest.length > 9) {
          lastBoardId += 10;
        }
      } else {
        print("Status code: ${data.statusCode}");
        print("Response body: ${data.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
    refreshController1.refreshCompleted();
  }

  Future<void> requestMyParticipantTest() async {
    try {
      String url = "${Common.url}myPages/boards/participation";
      String? bearerToken =
      await FirebaseAuth.instance.currentUser!.getIdToken();

      Map<String, dynamic> queryParameters = {
        'lastBoardId': partilastBoardId.toString(),
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
          myPartiTest.clear();
          for (var jsonResult in jsonData) {
            MyUploadTest gather = MyUploadTest.fromJson(jsonResult);
            myPartiTest.add(gather);
          }
          if (myPartiTest.length > 9) {
            partilastBoardId += 10;
          }
        }
      } else {
        print("Status code: ${data.statusCode}");
        print("Response body: ${data.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
    refreshController2.refreshCompleted();
  }

  @override
  void onInit() {
    getUserName();
    super.onInit();
  }

}