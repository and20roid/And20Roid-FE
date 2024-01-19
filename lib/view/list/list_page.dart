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
      backgroundColor: CustomColor.grey1,
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
                      likes: gatherListItems[index].likes,
                      views: gatherListItems[index].views,
                      urls: gatherListItems[index].imageUrls,
                      introLine: gatherListItems[index].introLine,
                      likedBoard: gatherListItems[index].likedBoard,
                    ));
              },
              child: renderCard(
                gatherListItems[index].participantNum.toString(),
                gatherListItems[index].title,
                gatherListItems[index].introLine,
                gatherListItems[index].imageUrls,
                gatherListItems[index].thumbnailUrl,
                gatherListItems[index].nickname,
                gatherListItems[index].likes,
                gatherListItems[index].views,
                MediaQuery.of(context).size.width,
                gatherListItems[index].likedBoard,
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _appBar() {
    List<Widget> dropbox = [
      Container(
        width: 90,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColor.primary3),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Text(
              "전체",
              style: TextStyle(
                color: CustomColor.primary3,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(width: 10, child: Image.asset("assets/icons/dropdown.png"))
          ],
        ),
      ),
      Container(
        width: 110,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColor.primary3),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Text(
              "모집 중",
              style: TextStyle(
                color: CustomColor.primary3,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(width: 10, child: Image.asset("assets/icons/dropdown.png"))
          ],
        ),
      ),
      Container(
        width: 130,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColor.primary3),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Text(
              "모집 완료",
              style: TextStyle(
                color: CustomColor.primary3,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(width: 10, child: Image.asset("assets/icons/dropdown.png"))
          ],
        ),
      ),
    ];

    return AppBar(toolbarHeight: 80.0,backgroundColor: CustomColor.grey1, title: dropbox[0]);
  }

  Card renderCard(
      String participantNum,
      String title,
      String intro,
      List<String> imageUrls,
      String thumbnailUrl,
      String nickname,
      int likes,
      int views,
      double screenWidth,
      bool liked) {
    return Card(
      color: CustomColor.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: CustomColor.primary2,
                ),
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  "$participantNum명의 테스터 참여 중",
                  style: TextStyle(
                      color: CustomColor.primary3,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
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
                      Text(
                        intro,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          imageList(imageUrls, screenWidth),
          threeTitle(nickname, likes.toString(), views.toString(), liked),
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

  Widget imageList(List<String> urls, double screenWidth) {
    return SizedBox(
      height: screenWidth / 1.5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 6.0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColor.grey5, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0)
              ),
              width: screenWidth / 3.5, // 화면 너비의 3분의 1 크기로 설정
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: CachedNetworkImage(
                  imageUrl: urls[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),

          );
        },
      ),
    );
  }

  Widget threeTitle(String nickname, String heart, String views, bool liked) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Text(nickname),
          const SizedBox(width: 16),
          liked
              ? const Icon(Icons.favorite, color: Colors.red)
              : const Icon(Icons.favorite_border_outlined,
                  color: Colors.red), // Heart icon
          Text(" $heart"),
          const SizedBox(width: 16),
          const Icon(Icons.visibility_outlined), // View count icon
          Text(' $views')
        ],
      ),
    );
  }
}
