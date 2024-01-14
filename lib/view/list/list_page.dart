import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../model/list_model.dart';
import '../../utility/common.dart';
import 'list_detail.dart';

class ListContent extends StatefulWidget {
  @override
  State<ListContent> createState() => _ListContentState();
}

class _ListContentState extends State<ListContent> {
  final List<GatherList> gatherListItems = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int lastBoardId = 0;
  bool isWaiting = true;

  init() async {
    await requestRecruitingList();
  }

  Future<void> requestRecruitingList() async {
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

          for (var jsonResult in jsonData) {
            GatherList gatherList = GatherList.fromJson(jsonResult);
            gatherListItems.add(gatherList);
          }

          lastBoardId += 10;

          setState(() {
            isWaiting = false;
          });
        }
      } else {
        print("Status code: ${data.statusCode}");
        print("Response body: ${data.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: requestRecruitingList,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: gatherListItems.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                print(gatherListItems[index].id);
                Get.to(() => ListDetail(
                      intValue: gatherListItems[index].id,
                      title: gatherListItems[index].title,
                      nickname: gatherListItems[index].nickname,
                      createdDate: gatherListItems[index].createdDate,
                      thumbnailUrl: gatherListItems[index].thumbnailUrl,
                    ));
              },
              child: renderCard(
                gatherListItems[index].participantNum.toString(),
                gatherListItems[index].title,
                // gatherListItems[index].content,
                gatherListItems[index].thumbnailUrl,
                gatherListItems[index].nickname,
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColor.pointColor),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          "모집 중",
          style: TextStyle(
            color: CustomColor.pointColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Card renderCard(
      String participantNum,
      String title,
      // String? content,
      // List<String> urls,
      String thumbnailUrl,
      String nickname) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                color: Colors.amber,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(" $participantNum명의 테스터 참여중 "),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
            child: Row(
              children: [
                appIcon(thumbnailUrl),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      // Text(content),
                      Text("안드로이드 앱 테스터 커뮤니티 서비스")
                    ],
                  ),
                ),
              ],
            ),
          ),
          /// imageList(),
          /// threeTitle(),
        ],
      ),
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

  Widget imageList(List<String> urls) {
    return ListView.builder(
      itemCount: urls.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: CachedNetworkImage(
            imageUrl: urls[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  Widget threeTitle(String nickname, String heart, String views) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Text(nickname),
          SizedBox(width: 16),
          Icon(Icons.favorite_border_outlined, color: Colors.red), // Heart icon
          Text(" $heart"),
          SizedBox(width: 16),
          Icon(Icons.visibility_outlined), // View count icon
          // Text("$viewCount"), // View coun
          Text(' $views')
        ],
      ),
    );
  }
}
