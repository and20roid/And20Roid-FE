import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../model/ranking_model.dart';
import '../../utility/common.dart';
import '../mypage/another_mypage.dart';

class RankingContent extends StatefulWidget {
  @override
  State<RankingContent> createState() => _RankingContentState();
}

class _RankingContentState extends State<RankingContent> {
  List<Rank> rankList = [];
  List<Map<String, dynamic>> dummyList = [
    // 더미 데이터
    {
      'rank': 1,
      'nickname': 'John Doe',
      'completedTestCount': 10,
      'userId': 'user123',
    },
    {
      'rank': 2,
      'nickname': 'John Doe',
      'completedTestCount': 10,
      'userId': 'user123',
    },
    {
      'rank': 3,
      'nickname': 'John Doe',
      'completedTestCount': 10,
      'userId': 'user123',
    },
    {
      'rank': 4,
      'nickname': 'John Doe',
      'completedTestCount': 10,
      'userId': 'user123',
    },
    {
      'rank': 5,
      'nickname': 'Kohn Doe',
      'completedTestCount': 8,
      'userId': 'user123',
    },

    // 추가적인 실제 데이터가 있다면 이어서 추가
  ];

  void movePage(String userName, int userId, String ranking) {
    Get.to(() =>
        RequestTest(userName: userName, userId: userId, ranking: ranking));
  }

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
            print("ranking : $jsonResult, length : ${jsonData.length}");
            Rank ranking = Rank.fromJson(jsonResult);
            rankList.add(ranking);
            setState(() {});
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
    init();
    super.initState();
  }

  init() async {
    await requestTotalRanking();
  }

  @override
  Widget build(BuildContext context) {
    return (rankList.isEmpty)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: CustomColor.grey1,
            body: Column(
              children: [
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Text('랭킹',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    ),
                    Spacer()
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      trophy(
                          '1',
                          rankList.first.nickname,
                          rankList.first.completedTestCount.toString(),
                          "assets/images/Vector.png",
                          rankList.first.userId),
                      (rankList.length > 1)
                          ? trophy(
                              '2',
                              rankList[1].nickname,
                              rankList[1].completedTestCount.toString(),
                              "assets/images/Vector-1.png",
                              rankList[1].userId)
                          : trophy('2', 'seungw2n', '100',
                              "assets/images/Vector-1.png", 2),
                      (rankList.length > 2)
                          ? trophy(
                              '3',
                              rankList[2].nickname,
                              rankList[2].completedTestCount.toString(),
                              "assets/images/Vector-2.png",
                              rankList[2].userId)
                          : trophy('3', 'seungw3n', '98',
                              "assets/images/Vector-2.png", 3),
                    ],
                  ),
                ),
                const ListTile(
                  title: Text(
                    '아이디',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  leading: Text(
                    '순위',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  trailing: Text('테스트 횟수',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Container(
                    color: CustomColor.grey1,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        // 4등부터의 데이터를 가져옴
                        Map<String, dynamic> playerData =
                            rankList[index + 3] as Map<String, dynamic>;
                        String playerName = playerData['nickname'];
                        int ranking = playerData['rank'];
                        int testCount = playerData['completedTestCount'];

                        return InkWell(
                          onTap: () {
                            movePage(playerName, playerData['userId'],
                                ranking.toString());
                          },
                          child: ListTile(
                            title: Text(
                              '$playerName',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            leading: Text(
                              '$ranking등',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            trailing: Text(
                              '$testCount회',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                      itemCount: rankList.length > 3 ? rankList.length - 3 : 0,
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget trophy(
      String ranking, String name, String count, String imagePath, int userId) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0), color: CustomColor.white),
      child: InkWell(
        onTap: () {
          movePage(name, userId, ranking);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                  child: (ranking == '1')
                      ? Image.asset('assets/icons/1st.png')
                      : (ranking == '2')
                          ? Image.asset('assets/icons/2nd.png')
                          : Image.asset('assets/icons/3rd.png')),
              Container(
                width: 90,
                height: 100,
                child: Image.asset(imagePath),
              ),
              Text(
                "$name\n$count회",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
