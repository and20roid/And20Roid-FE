import 'dart:convert';

import 'package:and20roid/view/ranking/ranking_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../model/ranking_model.dart';
import '../../utility/common.dart';
import '../mypage/another_mypage.dart';

class RankingContent extends StatelessWidget {
  final rankCtrl = Get.find<RankingController>();

  void movePage(
      String userName, int userId, String ranking, int helpEach, bool related) {
    Get.to(
        () => RequestTest(
            userName: userName,
            userId: userId,
            ranking: ranking,
            helpEach: helpEach,
            related: related),
        transition: Transition.fadeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: CustomColor.grey1,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                (rankCtrl.rankList.isEmpty)
                    ? trophy('1', '1등', 0.toString(), "assets/images/Vector.png",
                        0, 0, false)
                    : trophy(
                        '1',
                        rankCtrl.rankList.first.nickname,
                        rankCtrl.rankList.first.completedTestCount.toString(),
                        "assets/images/Vector.png",
                        rankCtrl.rankList.first.userId,
                        (rankCtrl.rankList.first.interactionCountAsUploader +
                            rankCtrl.rankList.first.interactionCountAsTester),
                        rankCtrl.rankList.first.relatedUser),
                (rankCtrl.rankList.length > 1)
                    ? trophy(
                        '2',
                        rankCtrl.rankList[1].nickname,
                        rankCtrl.rankList[1].completedTestCount.toString(),
                        "assets/images/Vector-1.png",
                        rankCtrl.rankList[1].userId,
                        (rankCtrl.rankList[1].interactionCountAsUploader +
                            rankCtrl.rankList[1].interactionCountAsTester),
                        rankCtrl.rankList[1].relatedUser,
                      )
                    : const SizedBox(
                        height: 220,
                        width: 120,
                      ),
                (rankCtrl.rankList.length > 2)
                    ? trophy(
                        '3',
                        rankCtrl.rankList[2].nickname,
                        rankCtrl.rankList[2].completedTestCount.toString(),
                        "assets/images/Vector-2.png",
                        rankCtrl.rankList[2].userId,
                        (rankCtrl.rankList[2].interactionCountAsUploader +
                            rankCtrl.rankList[2].interactionCountAsTester),
                        rankCtrl.rankList[2].relatedUser,
                      )
                    : const SizedBox(
                        height: 220,
                        width: 120,
                      )
              ],
            ),
          ),
          Divider(
            height: 0.1,
            color: CustomColor.grey2,
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: (rankCtrl.rankList.isEmpty)
                ? const Center(
                  child: Text(
                    "테스트를 완료한 유저가 없어요 🥲",
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      // 4등부터의 데이터를 가져옴
                      Rank playerData = rankCtrl.rankList[index + 3];
                      String playerName = playerData.nickname;
                      int ranking = playerData.rank;
                      int testCount = playerData.completedTestCount;
                      bool related = playerData.relatedUser;
                      int helpEach = playerData.interactionCountAsTester +
                          playerData.interactionCountAsUploader;

                      // Rank playerData = dummyList[index + 3];
                      // String playerName = playerData.nickname;
                      // int ranking = playerData.rank;
                      // int testCount = playerData.completedTestCount;
                      // bool related = playerData.relatedUser;
                      // int helpEach = playerData.interactionCountAsTester +
                      //     playerData.interactionCountAsUploader;

                      return InkWell(
                        onTap: () {
                          movePage(playerName, playerData.userId,
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
                    itemCount: rankCtrl.rankList.length > 3
                        ? rankCtrl.rankList.length - 3
                        : 0,
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
          if(userId!=0){
            movePage(name, userId, ranking, helpEach, relatedUser);
          }
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
      elevation: 1,
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
