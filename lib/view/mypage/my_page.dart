import 'dart:convert';

import 'package:and20roid/model/partici_member.dart';
import 'package:and20roid/view/list/list_detail.dart';
import 'package:and20roid/view/mypage/my_page_change.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../model/list_detail.dart';
import '../../model/mypage_tests.dart';
import '../../utility/common.dart';
import 'my_page_controller.dart';

class MyPageContent extends StatelessWidget {
  final myCtrl = Get.find<MyPageControllrer>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: GetBuilder<MyPageControllrer>(
      builder: (myCtrl) {
        return Scaffold(
            appBar: AppBar(
              toolbarHeight: 80,
              backgroundColor: CustomColor.grey1,
              title: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '${myCtrl.name}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: CustomColor
                            .primary1, // You can customize the color if needed
                      ),
                    ),
                    TextSpan(
                      text: ' 님의 페이지',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Get.to(() => const ChangeInfo(),
                          transition: Transition.rightToLeftWithFade);
                    },
                    icon: Icon(
                      Icons.settings,
                      size: 30,
                    ))
              ],
            ),
            backgroundColor: CustomColor.grey1,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: testInfo(" 랭킹", myCtrl.rank.toString(),
                              Icons.emoji_events_outlined, '등')),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: testInfo(
                              " 게시물",
                              myCtrl.uploadBoardCount.toString(),
                              Icons.upload_file_outlined,
                              '개')),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: testInfo(
                              " 완료",
                              myCtrl.completedTestCount.toString(),
                              Icons.done,
                              '회')),
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
                                      color: CustomColor.grey4, fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  '참여한 테스트',
                                  style: TextStyle(
                                      color: CustomColor.grey4, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                myCtrl.myUploadTest.isEmpty
                                    ? const Center(
                                        child: Text("업로드한 테스트가 없어요"),
                                      )
                                    : SmartRefresher(
                                        controller: myCtrl.refreshController1,
                                        enablePullDown: true,
                                        onRefresh: myCtrl.requestMyUploadTest,
                                        child: ListView.builder(
                                            itemCount:
                                                myCtrl.myUploadTest.length,
                                            itemBuilder: (context, index) {
                                              return joinMsgBox(
                                                  true,
                                                  myCtrl.myUploadTest[index].id,
                                                  myCtrl.myUploadTest[index]
                                                      .thumbnailUrl,
                                                  myCtrl.myUploadTest[index]
                                                      .title,
                                                  myCtrl.myUploadTest[index]
                                                      .introLine,
                                                  myCtrl.myUploadTest[index]
                                                      .recruitmentNum,
                                                  myCtrl.myUploadTest[index]
                                                      .participantNum,
                                                  myCtrl.myUploadTest[index]
                                                      .createdDate,
                                                  myCtrl.myUploadTest[index]
                                                      .state,
                                                  context);
                                            }),
                                      ),
                                myCtrl.myPartiTest.isEmpty
                                    ? const Center(
                                        child: Text("참여한 테스트가 없어요"),
                                      )
                                    : SmartRefresher(
                                        controller: myCtrl.refreshController2,
                                        enablePullDown: true,
                                        onRefresh:
                                            myCtrl.requestMyParticipantTest,
                                        child: ListView.builder(
                                            itemCount:
                                                myCtrl.myPartiTest.length,
                                            itemBuilder: (context, index) {
                                              return joinMsgBox(
                                                  false,
                                                  myCtrl.myPartiTest[index].id,
                                                  myCtrl.myPartiTest[index]
                                                      .thumbnailUrl,
                                                  myCtrl
                                                      .myPartiTest[index].title,
                                                  myCtrl.myPartiTest[index]
                                                      .introLine,
                                                  myCtrl.myPartiTest[index]
                                                      .recruitmentNum,
                                                  myCtrl.myPartiTest[index]
                                                      .participantNum,
                                                  myCtrl.myPartiTest[index]
                                                      .createdDate,
                                                  myCtrl
                                                      .myPartiTest[index].state,
                                                  context);
                                            }),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ));
      },
    ));
  }

  Widget testInfo(String title, String num, IconData icon, String danwi) {
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
                  Icon(icon),
                  Text(
                    '$title',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "$num$danwi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
          ],
        ));
  }
}

Widget joinMsgBox(
    bool isUp,
    int id,
    String thumbnailUrl,
    String title,
    String introLine,
    int pariNum,
    int recruNum,
    String createdDate,
    String state,
    BuildContext context) {
  ListDetailInfo listDetailInfo;
  List<PartiMember> partiMemberList = [];

  Future<ListDetailInfo> requestRecruitingDetail(id) async {
    try {
      String url = "${Common.url}boards/${id}";
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

          listDetailInfo = ListDetailInfo.fromJson(jsonResults);

          return listDetailInfo;
        }
      } else {
        print("Status code: ${data.statusCode}");
        print("Response body: ${data.body}");
      }
    } catch (e) {
      print('Error: $e');
    }

    return ListDetailInfo(
      content: 'content',
      appTestLink: 'appTestLink',
      webTestLink: 'webTestLink',
      participantNum: 0,
      imageUrls: ['imageUrls'],
      nickName: 'nickName',
      views: 0,
      likes: 0,
      likedBoard: false,
    );
  }

  Future<void> requestSeeMozipOne(id) async {
    try {
      String url = "${Common.url}participation/$id/participants";
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
          partiMemberList.clear();
          var jsonResults = jsonDecode(utf8.decode(data.bodyBytes));
          var jsonData = jsonResults['readParticipantResponses'];
          for (int i = 0; i < jsonData.length; i++) {
            partiMemberList.add(PartiMember.fromJson(jsonData[i]));
            print(jsonData[i]);
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

  Future<void> requestTestLinkBroadcast(boardId, context) async {
    try {
      String url = "${Common.url}boards/${boardId.toString()}/start";
      String? bearerToken =
          await FirebaseAuth.instance.currentUser!.getIdToken();

      var data = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $bearerToken',
        },
      );
      Map<String, dynamic> jsonBody = jsonDecode(utf8.decode(data.bodyBytes));
      String message = jsonBody['message'];
      print('message ~~~~~~~~ $message');

      if (data.statusCode == 200) {
        print('~~~~~~~~~test link complete ${utf8.decode(data.bodyBytes)}');
        Common().showToastN(context, message, 1);
      } else {
        print("Status code: ${data.statusCode}");
        print("Response body: ${data.body}");
        Common().showToastN(context, message, 1);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void showBottomModalSheet(
      BuildContext context, List<PartiMember> partiMemberList, int boardId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true for full width
      builder: (BuildContext context) {
        return (partiMemberList.isEmpty)
            ? SizedBox(
                height: 150,
                child: Center(
                  child: Text(
                    "참여한 테스터가 없습니다",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CustomColor.grey5),
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width,
                  child: (state == '모집중')
                      ? Stack(children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: partiMemberList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    leading: Text(
                                      (index+1).toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    title: Text(partiMemberList[index].email,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),),
                                  );
                                },
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      CustomColor.white),
                                  minimumSize:
                                      MaterialStateProperty.all(Size(310, 56)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      side:
                                          BorderSide(color: CustomColor.grey4),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  requestTestLinkBroadcast(boardId, context);
                                },
                                child: Text(
                                  "테스트 링크 전송",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColor.primary1),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                              bottom: 43,
                              right: 0,
                              child: BalloonWidget(
                                message: '한번만 전송할 수 있어요',
                              ))
                        ])
                      : Column(mainAxisSize: MainAxisSize.min, children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: partiMemberList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: Text(
                                  (index+1).toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                title: Text(partiMemberList[index].email,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),),
                              );
                            },
                          ),
                        ]),
                ),
              );
      },
    );
  }

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
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          introLine,
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                  isUp ? Spacer() : Container(),
                  isUp
                      ? InkWell(
                          onTap: () async {
                            await requestSeeMozipOne(id);
                            showBottomModalSheet(context, partiMemberList, id);
                          },
                          child: Container(
                            height: 28,
                            width: 72,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: CustomColor.primary1,
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.people),
                                Text(
                                  " $recruNum/$pariNum",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  children: [
                    (state == '모집중')
                        ? Expanded(
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    CustomColor.primary1),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                await requestRecruitingDetail(id)
                                    .then((listDetailInfo) {
                                  Get.to(() => ListDetail(
                                      intValue: id,
                                      title: title,
                                      nickname: listDetailInfo.nickName,
                                      createdDate: createdDate,
                                      thumbnailUrl: thumbnailUrl,
                                      likes: listDetailInfo.likes,
                                      views: listDetailInfo.views,
                                      urls: listDetailInfo.imageUrls,
                                      introLine: introLine,
                                      likedBoard: listDetailInfo.likedBoard));
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.list_alt_outlined,
                                      color: CustomColor.grey5),
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
                          )
                        : (state == '모집완료')
                            ? Expanded(
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        CustomColor.primary2),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await requestRecruitingDetail(id)
                                        .then((listDetailInfo) {
                                      Get.to(() => ListDetail(
                                          intValue: id,
                                          title: title,
                                          nickname: listDetailInfo.nickName,
                                          createdDate: createdDate,
                                          thumbnailUrl: thumbnailUrl,
                                          likes: listDetailInfo.likes,
                                          views: listDetailInfo.views,
                                          urls: listDetailInfo.imageUrls,
                                          introLine: introLine,
                                          likedBoard:
                                              listDetailInfo.likedBoard));
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.playlist_add_check,
                                          color: CustomColor.primary3),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        '글 보러가기',
                                        style: TextStyle(
                                            color: CustomColor.primary3,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : (state == '테스트중')
                                ? Expanded(
                                    child: TextButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                CustomColor.primary2),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await requestRecruitingDetail(id)
                                            .then((listDetailInfo) {
                                          Get.to(() => ListDetail(
                                              intValue: id,
                                              title: title,
                                              nickname: listDetailInfo.nickName,
                                              createdDate: createdDate,
                                              thumbnailUrl: thumbnailUrl,
                                              likes: listDetailInfo.likes,
                                              views: listDetailInfo.views,
                                              urls: listDetailInfo.imageUrls,
                                              introLine: introLine,
                                              likedBoard:
                                                  listDetailInfo.likedBoard));
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.science_outlined,
                                              color: CustomColor.primary1),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            '테스트 중',
                                            style: TextStyle(
                                                color: CustomColor.primary1,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: TextButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                CustomColor.primary1),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Common().showToastN(
                                            context, '완료된 테스트입니다', 4);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.list_alt_outlined,
                                              color: CustomColor.grey5),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            '테스트 완료',
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

class BalloonWidget extends StatelessWidget {
  final String message;

  BalloonWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: CustomColor.primary1, // 말풍선 배경색
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            size: 20,
            Icons.warning,
            color: CustomColor.primary3, // 경고 아이콘 색상
          ),
          Text(
            message,
            style: TextStyle(
              fontSize: 12,
              color: CustomColor.grey5, // 메시지 텍스트 색상
            ),
          ),
        ],
      ),
    );
  }
}
