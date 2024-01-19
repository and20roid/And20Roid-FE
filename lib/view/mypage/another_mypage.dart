import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/user_model.dart';
import '../../utility/common.dart';

class RequestTest extends StatefulWidget {
  final String userName;
  final int? userId; // userId 추가

  const RequestTest({Key? key, required this.userName, this.userId})
      : super(key: key);

  @override
  State<RequestTest> createState() => _RequestTestState();
}

class _RequestTestState extends State<RequestTest> {
  UserTestInfo? userTestInfo;

  Future<void> requestUserTestNum() async {
    try {
      int? userId = widget.userId;
      String url =
          "${Common.url}users${userId != null ? '?userId=$userId' : ''}";

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

  init() async {
    await requestUserTestNum();
  }

  @override
  Widget build(BuildContext context) {
    return (userTestInfo == null)
        ? const Center(child: CircularProgressIndicator())
        : SafeArea(
            child: Scaffold(
              appBar: _appBar(),
              backgroundColor: CustomColor.grey1,
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.userName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: testInfo(" 랭킹", '100등',
                                    'assets/icons/trophyIcon.png')),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: testInfo(" 횟수", '200',
                                    'assets/icons/pointIcon.png')),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: testInfo(" 서로도움", '200',
                                    'assets/icons/handshake.png'))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColor.primary1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12.0), // 모서리 radius 설정
                                ),
                                minimumSize: const Size.fromHeight(60)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/icons/handshake.png"),
                                const SizedBox(width: 8.0),
                                const Text(
                                  "내 테스트 참여 요청",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                // 글자색 설정
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        color: CustomColor.white,
                      ),
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              indicatorColor: CustomColor.primary1,
                              tabs: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    '업로드한 테스트',
                                    style: TextStyle(color: CustomColor.grey4, fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    '참여한 테스트',
                                    style: TextStyle(color: CustomColor.grey4, fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  // 첫 번째 탭의 내용
                                  Center(child: Text('업로드한 테스트 내용')),
                                  // 두 번째 탭의 내용
                                  Center(child: Text('참여한 테스트 내용')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Widget testInfo(String title, String num, String iconPath) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: Colors.white),
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 앞쪽 정렬 설정
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Image.asset(iconPath),
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                num,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
          ],
        ));
  }
}

AppBar _appBar() {
  return AppBar(
    backgroundColor: CustomColor.grey1,
    title: Text(
      "다른 테스터 정보",
      style: TextStyle(fontSize: 18, color: CustomColor.grey5),
    ),
  );
}
