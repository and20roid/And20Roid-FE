import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/user_model.dart';
import '../../utility/common.dart';

class RequestTest extends StatefulWidget {
  final String userName;
  final int userId;
  const RequestTest({Key? key, required this.userName, required this.userId})
      : super(key: key);
  @override
  State<RequestTest> createState() => _RequestTestState();
}

class _RequestTestState extends State<RequestTest> {

  UserTestInfo? userTestInfo;

  Future<void> requestUserTestNum() async {
    try {
      String url = "${Common.url}users/${widget.userId}";
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
          setState(() {
            userTestInfo = UserTestInfo.fromJson(jsonResults);
          });
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
  void initState() {
    init();
    super.initState();
  }

  init()async{
    await requestUserTestNum();
  }

  @override
  Widget build(BuildContext context) {
    return (userTestInfo == null) ? const Center(child: CircularProgressIndicator()):SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  '나와의 관계 : 테스트를 도와줬던 분',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: testInfo("테스트 진행 횟수", userTestInfo!.completedTestCount.toString())),
                  SizedBox(width: 10,),
                  Expanded(child: testInfo("테스트 의뢰 횟수", userTestInfo!.uploadBoardCount.toString())),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () {
                    print("touched");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CupertinoColors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // 모서리 radius 설정
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "테스트 요청하기",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      // 글자색 설정
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget testInfo(String title, String num) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.cyan
      ),
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 앞쪽 정렬 설정
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "$num회",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
          ],
        ));
  }
}
