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

  void movePage(String userName, int userId){
    Get.to(()=>RequestTest(userName: userName, userId :userId));
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

  init() async{
    await requestTotalRanking();
  }

  @override
  Widget build(BuildContext context) {
    return (rankList.isEmpty)?Center(
        child: CircularProgressIndicator(),
      ):Scaffold(
      body: Column(
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Text('랭킹',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              Spacer()
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                trophy('2','seungw2n','100',"assets/images/Vector-1.png",2),
                trophy('1',rankList.first.nickname,rankList.first.completedTestCount.toString(),"assets/images/Vector.png",rankList.first.userId),
                trophy('3','seungw3n','98',"assets/images/Vector-2.png",3),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[200], // 리스트뷰의 배경색
              child: ListView.builder(
                itemBuilder: (context, index) {
                  // 4등부터의 데이터를 가져옴
                  Map<String, dynamic> playerData = rankList[index + 3] as Map<String, dynamic>;
                  String playerName = playerData['nickname'];
                  int ranking = playerData['rank'];
                  int testCount = playerData['completedTestCount'];

                  return InkWell(
                    onTap: () {
                      movePage(playerName,playerData['userId']);
                    },
                    child: ListTile(
                      title: Text('$ranking등 $playerName'),
                      trailing: Text('$testCount회'),
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

  Widget trophy(String ranking, String name, String count, String imagePath, int userId) {
    return InkWell(
      onTap: (){
        movePage(name,userId);
      },
      child: Column(
        children: [
          (ranking == '1')?
          Container():const SizedBox(
            height: 60,
          ),
          Container(
            width: 50,
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Image.asset(imagePath),
          ),
          Text(
            "$ranking등\n$name\n$count회",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
