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

class MyPageContent extends StatefulWidget {
  @override
  State<MyPageContent> createState() => _MyPageContentState();
}

class _MyPageContentState extends State<MyPageContent> {
  final SaveSharedPreferences sharedPreferences = SaveSharedPreferences();
  final RefreshController _refreshController1 =
      RefreshController(initialRefresh: false);
  final RefreshController _refreshController2 =
      RefreshController(initialRefresh: false);

  String? name;
  String? profileUrl;
  int lastBoardId = 0;
  int partilastBoardId = 0;
  int completedTestCount = 0;
  int uploadBoardCount = 0;

  List<MyUploadTest> myUploadTest = [];
  List<MyUploadTest> myPartiTest = [];

  Future<void> getUserName() async {
    name = await sharedPreferences.getUserNick();
    profileUrl = await sharedPreferences.getUserProfile();
    await requestMyUploadTest();
    await requestMyParticipantTest();
    await requestMyInfo();
    setState(() {});
  }

  Future<void> requestMyInfo() async {
    try {
      String url = "${Common.url}users";
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
          completedTestCount = jsonResults['completedTestCount'];
          uploadBoardCount = jsonResults['uploadBoardCount'];
        }
      } else {
        print("Status code: ${data.statusCode}");
        print("Response body: ${data.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
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
          myUploadTest.clear();
          for (var jsonResult in jsonData) {
            print(jsonResult);
            MyUploadTest gather = MyUploadTest.fromJson(jsonResult);
            print(
                '----------------------------업로드한 테스트 ------------------------');

            myUploadTest.add(gather);
          }
        }
        if (myUploadTest.length > 9) {
          lastBoardId += 10;
        }
      } else {
        print("Status code: ${data.statusCode}");
        print("Response body: ${data.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
    _refreshController1.refreshCompleted();
    setState(() {});
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
          myPartiTest.clear();
          for (var jsonResult in jsonData) {
            MyUploadTest gather = MyUploadTest.fromJson(jsonResult);
            myPartiTest.add(gather);
          }
          if (myPartiTest.length > 9) {
            partilastBoardId += 10;
          }
        }
      } else {
        print("Status code: ${data.statusCode}");
        print("Response body: ${data.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
    _refreshController2.refreshCompleted();
    setState(() {});
  }

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 80,
              backgroundColor: CustomColor.grey1,
              title: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '$name',
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
                      // Expanded(
                      //     child: testInfo(" 랭킹", '100등',
                      //         'assets/icons/trophyIcon.png')),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      Expanded(
                          child: testInfo(
                              " 업로드한 테스트",
                              uploadBoardCount.toString(),
                              Icons.upload_file_outlined)),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: testInfo(" 완료한 테스트",
                              completedTestCount.toString(), Icons.done)),
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
                                myUploadTest.isEmpty
                                    ? const Center(
                                        child: Text("업로드한 테스트가 없어요"),
                                      )
                                    : SmartRefresher(
                                        controller: _refreshController1,
                                        enablePullDown: true,
                                        onRefresh: requestMyUploadTest,
                                        child: ListView.builder(
                                            itemCount: myUploadTest.length,
                                            itemBuilder: (context, index) {
                                              return joinMsgBox(
                                                  true,
                                                  myUploadTest[index].id,
                                                  myUploadTest[index]
                                                      .thumbnailUrl,
                                                  myUploadTest[index].title,
                                                  myUploadTest[index].introLine,
                                                  myUploadTest[index]
                                                      .recruitmentNum,
                                                  myUploadTest[index]
                                                      .participantNum,
                                                  myUploadTest[index]
                                                      .createdDate,
                                                  myUploadTest[index].state,
                                                  context);
                                            }),
                                      ),
                                myPartiTest.isEmpty
                                    ? const Center(
                                        child: Text("참여한 테스트가 없어요"),
                                      )
                                    : SmartRefresher(
                                        controller: _refreshController2,
                                        enablePullDown: true,
                                        onRefresh: requestMyParticipantTest,
                                        child: ListView.builder(
                                            itemCount: myPartiTest.length,
                                            itemBuilder: (context, index) {
                                              return joinMsgBox(
                                                  false,
                                                  myPartiTest[index].id,
                                                  myPartiTest[index]
                                                      .thumbnailUrl,
                                                  myPartiTest[index].title,
                                                  myPartiTest[index].introLine,
                                                  myPartiTest[index]
                                                      .recruitmentNum,
                                                  myPartiTest[index]
                                                      .participantNum,
                                                  myPartiTest[index]
                                                      .createdDate,
                                                  myPartiTest[index].state,
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
            )));
  }

  Widget testInfo(String title, String num, IconData icon) {
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
                "$num회",
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
                                    leading: Text(partiMemberList[index]
                                        .userId
                                        .toString()),
                                    title: Text(partiMemberList[index].email),
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
                                    partiMemberList[index].userId.toString()),
                                title: Text(partiMemberList[index].email),
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
