import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../model/mypage_tests.dart';
import '../../utility/common.dart';

class MyPageControllrer extends GetxController {
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

  String? emailName;

  List<MyUploadTest> myUploadTest = [];
  List<MyUploadTest> myPartiTest = [];

  Future<void> getUserName() async {
    emailName = await sharedPreferences.getUserNick();
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

          print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~name $name');
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
      lastBoardId = 0;
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
          myUploadTest.clear();
          var jsonResults = jsonDecode(utf8.decode(data.bodyBytes));
          var jsonData = jsonResults['readBoardResponses'];
          print(jsonData);

          for (var jsonResult in jsonData) {
            MyUploadTest gather = MyUploadTest.fromJson(jsonResult);

            myUploadTest.add(gather);
          }
          update();
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

  Future<void> requestDownMyUploadTest() async {
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
          List<int> existingIds = myUploadTest.map((item) => item.id).toList();
          print(
              '----------------------------업로드한 테스트 ------------------------');
          print(jsonData);
          for (var jsonResult in jsonData) {
            MyUploadTest gather = MyUploadTest.fromJson(jsonResult);

            // 새로운 GatherList의 id가 중복되지 않으면 추가
            if (!existingIds.contains(gather.id)) {
              myUploadTest.add(gather);
            }
          }
          lastBoardId = existingIds
              .reduce((value, element) => value < element ? value : element);
        }
      } else {
        print("Status code: ${data.statusCode}");
        print("Response body: ${data.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
    refreshController1.loadComplete();
  }

  Future<void> requestMyParticipantTest() async {
    try {
      partilastBoardId = 0;
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
          myPartiTest.clear();
          var jsonResults = jsonDecode(utf8.decode(data.bodyBytes));

          var jsonData = jsonResults['readBoardResponses'];
          for (var jsonResult in jsonData) {
            MyUploadTest gather = MyUploadTest.fromJsonD(jsonResult);

            myPartiTest.add(gather);
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

  Future<void> requestDownMyParticipantTest() async {
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
          List<int> existingIds = myPartiTest.map((item) => item.id).toList();

          for (var jsonResult in jsonData) {
            MyUploadTest gather = MyUploadTest.fromJsonD(jsonResult);

            if (!existingIds.contains(gather.id)) {
              myPartiTest.add(gather);
            }
          }
          partilastBoardId = existingIds
              .reduce((value, element) => value < element ? value : element);
        }
        update();
      } else {
        print("Status code: ${data.statusCode}");
        print("Response body: ${data.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
    refreshController2.loadComplete();
  }

  @override
  void onInit() {
    getUserName();
    super.onInit();
  }
}
