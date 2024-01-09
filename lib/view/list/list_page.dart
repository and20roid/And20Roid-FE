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
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  int lastBoardId = 0;
  bool isWaiting = true;

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
    requestRecruitingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: requestRecruitingList,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: gatherListItems.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                print(gatherListItems[index].id);
                Get.to(() => ListDetail( intValue: gatherListItems[index].id, title: gatherListItems[index].title, nickname: gatherListItems[index].nickname,createdDate : gatherListItems[index].createdDate,));
              },
              child: Card(
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 60,
                      child: CachedNetworkImage(
                          imageUrl :gatherListItems[index]
                              .thumbnailUrl), // 이미지 URL을 사용하여 이미지 표시
                    ),
                    Text(gatherListItems[index].title),
                    Text(gatherListItems[index].nickname),
                    Text("현재 ${gatherListItems[index].state}"),
                    Row(
                      children: [
                        Icon(Icons.person),
                        Text("${gatherListItems[index].participantNum}/${gatherListItems[index].recruitmentNum}")
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.timelapse),
                        Text("${gatherListItems[index].createdDate.substring(0,16)}")
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
