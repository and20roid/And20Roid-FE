import 'dart:convert';

import 'package:and20roid/model/partici_member.dart';
import 'package:and20roid/view/list/list_detail.dart';
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
        child: profileUrl == null
            ? CircularProgressIndicator()
            : Scaffold(
            appBar: AppBar(
              toolbarHeight: 80,
              backgroundColor: CustomColor.grey1,
              title: Row(
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
              actions: [
                IconButton(
                    onPressed: () {},
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
                                            myUploadTest[index]
                                                .introLine,
                                            myUploadTest[index]
                                                .recruitmentNum,
                                            myUploadTest[index]
                                                .participantNum,
                                            myUploadTest[index]
                                                .createdDate,
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
                                            myPartiTest[index]
                                                .introLine,
                                            myPartiTest[index]
                                                .recruitmentNum,
                                            myPartiTest[index]
                                                .participantNum,
                                            myPartiTest[index]
                                                .createdDate,
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

Widget joinMsgBox(bool isUp,
    int id,
    String thumbnailUrl,
    String title,
    String introLine,
    int pariNum,
    int recruNum,
    String createdDate,
    BuildContext context) {
  ListDetailInfo listDetailInfo;
  List<PartiMember> partiMemberList = [];

  Future<ListDetailInfo> requestRecruitingDetail(id) async {
    try {
      String url = "${Common.url}boards/${id}";
      String? bearerToken = await FirebaseAuth.instance.currentUser!
          .getIdToken();

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

    return ListDetailInfo(content: 'content',
        appTestLink: 'appTestLink',
        webTestLink: 'webTestLink',
        participantNum: 0,
        imageUrls: ['imageUrls'],
        nickName: 'nickName',
        views: 0,
        likes: 0,
        likedBoard : false
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

  void showBottomModalSheet(context, partiMemberList) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true for full width
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: partiMemberList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Text(partiMemberList[index].userId.toString()),
                      title: Text(partiMemberList[index].email),

                    );
                  },
                ),
              ],
            ),
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
                      showBottomModalSheet(context, partiMemberList);
                    },
                    child: Container(
                      height: 28,
                      width: 67,
                      padding: const EdgeInsets.only(left: 3),
                      child: Center(
                        child: Row(
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
                      decoration: BoxDecoration(
                          color: CustomColor.primary1,
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                  )
                      : Container()
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
                        onPressed: () async {
                          await requestRecruitingDetail(id).then((listDetailInfo){
                            Get.to(() =>
                                ListDetail(
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
