import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/mypage_tests.dart';
import '../../utility/common.dart';
import 'another_mypage.dart';

class MyPageContent extends StatefulWidget {
  @override
  State<MyPageContent> createState() => _MyPageContentState();
}

class _MyPageContentState extends State<MyPageContent> {
  final SaveSharedPreferences sharedPreferences = SaveSharedPreferences();

  String? name;
  String? profileUrl;
  int lastBoardId = 0;
  int partilastBoardId = 0;

  List<MyUploadTest> myUploadTest = [];
  List<MyUploadTest> myPartiTest = [];

  Future<void> _getUserName() async {
    name = await sharedPreferences.getUserNick();
    profileUrl = await sharedPreferences.getUserProfile();
    await requestMyUploadTest();
    await requestMyParticipantTest();
    setState(() {});
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

          for (var jsonResult in jsonData) {
            MyUploadTest gather = MyUploadTest.fromJson(jsonResult);
            print(
                '----------------------------업로드한 테스트 ------------------------');
            myUploadTest.add(gather);
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
          print('----------------------------참여한 테스트 ------------------------');

          for (var jsonResult in jsonData) {
            MyUploadTest gather = MyUploadTest.fromJson(jsonResult);
                        myPartiTest.add(gather);
            print(gather);
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
  void initState() {
    _getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: profileUrl == null
            ? CircularProgressIndicator()
            : Scaffold(
                backgroundColor: CustomColor.grey1,
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: profileUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Text(
                            ' $name',
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: testInfo(" 랭킹", '100등',
                                  'assets/icons/trophyIcon.png')),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: testInfo(" 게시물", '200P',
                                  'assets/icons/pointIcon.png')),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: testInfo(
                                  " 참여수", '200P', 'assets/icons/pointIcon.png'))
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
                                      style: TextStyle(
                                          color: CustomColor.grey4,
                                          fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      '참여한 테스트',
                                      style: TextStyle(
                                          color: CustomColor.grey4,
                                          fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    myUploadTest.isEmpty
                                        ? const Center(
                                            child: Text("업로드한 테스트가 없어요"),
                                          )
                                        : ListView.builder(
                                            itemCount: myUploadTest.length,
                                            itemBuilder: (context, index) {
                                              return joinMsgBox(
                                                  myUploadTest[index].thumbnailUrl,myUploadTest[index].title,myUploadTest[index].introLine,myUploadTest[index].recruitmentNum,myUploadTest[index].participantNum);
                                            }),
                                    myPartiTest.isEmpty
                                        ? const Center(
                                            child: Text("참여한 테스트가 없어요"),
                                          )
                                        : ListView.builder(
                                            itemCount: myPartiTest.length,
                                            itemBuilder: (context, index) {
                                              return joinMsgBox(
                                                  myPartiTest[index].thumbnailUrl,myPartiTest[index].title,myPartiTest[index].introLine,myPartiTest[index].recruitmentNum,myPartiTest[index].participantNum);
                                            }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )));
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
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
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

Widget CustomListTile(List<MyUploadTest> testList, int index) {
  return Column(
    children: [
      ListTile(
        leading: ClipOval(
          child: CircleAvatar(
            radius: 30, // 프로필 사진 크기 조절
            backgroundImage: NetworkImage(testList[index].thumbnailUrl),
          ),
        ),
        title: Text(testList[index].title),
        subtitle: Text(testList[index].introLine),
      ),
      CustomButton()
    ],
  );
}

ElevatedButton CustomButton() {
  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
        backgroundColor: CustomColor.primary1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // 모서리 radius 설정
        ),
        minimumSize: const Size.fromHeight(60)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/icons/email.png"),
        // 아이콘 색상 설정
        const SizedBox(width: 8.0),
        // 아이콘과 텍스트 사이의 간격 조절
        const Text(
          "참여하기",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        // 글자색 설정
      ],
    ),
  );
}

Widget joinMsgBox(String thumbnailUrl, String title, String introLine,int pariNum, int recruNum) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(children: [
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  appIcon(thumbnailUrl),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          introLine,
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(CustomColor.primary1),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/icons/email.png"),
                            // 아이콘 색상 설정
                            const SizedBox(width: 8.0),
                            Text(
                              '글 보러가기',
                              style: TextStyle(
                                  color: CustomColor.grey5,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    ]),
  );
}

Widget appIcon(String thumbnailUrl) {
  return SizedBox(
    height: 60,
    width: 60,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: CachedNetworkImage(
        fit: BoxFit.fill,
        imageUrl: thumbnailUrl,
      ),
    ),
  );
}
