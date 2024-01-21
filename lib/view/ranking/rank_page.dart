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
  List<Rank> dummyList = [
    Rank(
      rank: 1,
      nickname: 'John Doe',
      completedTestCount: 10,
      userId: 1,
      interactionCountAsTester: 5,
      interactionCountAsUploader: 3,
      relatedUser: true,
    ),
    Rank(
      rank: 2,
      nickname: 'John Doe',
      completedTestCount: 10,
      userId: 2,
      interactionCountAsTester: 5,
      interactionCountAsUploader: 3,
      relatedUser: false,
    ),
    Rank(
      rank: 3,
      nickname: 'John Doe',
      completedTestCount: 10,
      userId: 3,
      interactionCountAsTester: 5,
      interactionCountAsUploader: 3,
      relatedUser: true,
    ),
    Rank(
      rank: 4,
      nickname: 'John Doe',
      completedTestCount: 10,
      userId: 4,
      interactionCountAsTester: 5,
      interactionCountAsUploader: 3,
      relatedUser: true,
    ),
    Rank(
      rank: 5,
      nickname: 'Kohn Doe',
      completedTestCount: 8,
      userId: 5,
      interactionCountAsTester: 5,
      interactionCountAsUploader: 3,
      relatedUser: false,
    ),
  ];

  void movePage(
      String userName, int userId, String ranking, int helpEach, bool related) {
    Get.to(() => RequestTest(
        userName: userName,
        userId: userId,
        ranking: ranking,
        helpEach: helpEach,
        related: related));
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
            print("ranking : $jsonResult");
            Rank ranking = Rank.fromJson(jsonResult);
            rankList.add(ranking);
          }
          setState(() {});
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
            appBar: _appBar(),
            backgroundColor: CustomColor.grey1,
            body: Column(
              children: [
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
                          rankList.first.userId,
                          (rankList.first.interactionCountAsUploader +
                              rankList.first.interactionCountAsTester),
                          rankList.first.relatedUser),
                      (rankList.length > 1)
                          ? trophy(
                              '2',
                              rankList[1].nickname,
                              rankList[1].completedTestCount.toString(),
                              "assets/images/Vector-1.png",
                              rankList[1].userId,
                              (rankList[1].interactionCountAsUploader +
                                  rankList[1].interactionCountAsTester),
                              rankList[1].relatedUser,
                            )
                          : const SizedBox(
                              height: 220,
                              width: 120,
                            ),
                      (rankList.length > 2)
                          ? trophy(
                              '3',
                              rankList[2].nickname,
                              rankList[2].completedTestCount.toString(),
                              "assets/images/Vector-2.png",
                              rankList[2].userId,
                              (rankList[2].interactionCountAsUploader +
                                  rankList[2].interactionCountAsTester),
                              rankList[2].relatedUser,
                            )
                          : const SizedBox(
                              height: 220,
                              width: 120,
                            )
                      // trophy(
                      //           '3',
                      //           'nicknamsssssse',
                      //           'toString()',
                      //           "assets/images/Vector-2.png",
                      //           3,
                      //           3,
                      //           true,
                      //         ),
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
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      // 4등부터의 데이터를 가져옴
                      Map<String, dynamic> playerData =
                          rankList[index + 3] as Map<String, dynamic>;
                      String playerName = playerData['nickname'];
                      int ranking = playerData['rank'];
                      int testCount = playerData['completedTestCount'];
                      bool related = playerData['relatedUser'];
                      int helpEach = playerData['interactionCountAsTester'] +
                          playerData['interactionCountAsUploader'];

                      // Rank playerData = dummyList[index + 3];
                      // String playerName = playerData.nickname;
                      // int ranking = playerData.rank;
                      // int testCount = playerData.completedTestCount;
                      // bool related = playerData.relatedUser;
                      // int helpEach = playerData.interactionCountAsTester +
                      //     playerData.interactionCountAsUploader;

                      return InkWell(
                        onTap: () {
                          movePage(playerName, playerData['userId'],
                              ranking.toString(), helpEach, related);
                        },
                        // onTap: () {
                        //   movePage(
                        //       playerName,
                        //       playerData.userId,
                        //       ranking.toString(),
                        //       helpEach,
                        //       playerData.relatedUser);
                        // },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: CustomColor.primary1,
                                width: related ? 5.0 : 0,
                              ),
                            ),
                          ),
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
                            tileColor: related
                                ? CustomColor.primary4
                                : CustomColor.grey1,
                          ),
                        ),
                      );
                    },
                    // itemCount: dummyList.length > 3 ? dummyList.length - 3 : 0,
                    itemCount: rankList.length > 3 ? rankList.length - 3 : 0,
                  ),
                ),
              ],
            ),
          );
  }

  Widget trophy(String ranking, String name, String count, String imagePath,
      int userId, int helpEach, bool relatedUser) {
    return Container(
      height: 220,
      width: 120,
      decoration: BoxDecoration(
          border: (ranking == '1')
              ? Border.all(color: CustomColor.goldStroke)
              : (ranking == '2')
                  ? Border.all(color: CustomColor.silverStroke)
                  : Border.all(color: CustomColor.cooperStroke),
          borderRadius: BorderRadius.circular(8.0),
          color: relatedUser ? CustomColor.primary4 : CustomColor.white),
      child: InkWell(
        onTap: () {
          movePage(name, userId, ranking, helpEach, relatedUser);
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
              Flexible(
                child: Text(
                  "$name",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                "$count회",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: CustomColor.grey1,
      title: const Text(
        "랭킹",
        style: TextStyle(
            color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}
