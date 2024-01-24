import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/list_detail.dart';
import '../../model/noti_model.dart';
import '../../utility/common.dart';
import '../list/list_detail.dart';
import 'notification_controller.dart';

class NotificationContent extends StatelessWidget {
  final noti = Get.find<NotiController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        color: CustomColor.grey1,
        child: SmartRefresher(
          enablePullDown: true,
          controller: noti.refreshController,
          onRefresh: noti.requestUserTestNum,
          child: ListView.builder(
            itemCount: noti.notiData.length,
            itemBuilder: (context, index) {
              NotificationList data = noti.notiData[index];
              switch (data.type) {
                case 'request':
                  return requestMsgBox(data.content, data.thumbnailUrl!,
                      data.boardTitle!, data.introLine!, data.boardId!);
                case 'join':
                  return joinMsgBox(data.content, data.thumbnailUrl!,
                      data.boardTitle!, data.introLine!, data.boardId!);
                case 'start':
                  return startMsgBox(
                      data.content,
                      data.thumbnailUrl!,
                      data.boardTitle!,
                      data.introLine!,
                      data.appTestLink!,
                      data.webTestLink!,
                  context);
                case 'endUploader':
                  return endUploaderBox(data.content, data.thumbnailUrl!,
                      data.boardTitle!, data.introLine!, data.boardId!,context);
                case 'endTester':
                  return endTesterBox(data.content, data.thumbnailUrl!,
                      data.boardTitle!, data.introLine!, context);
                default:
                  return Container(); // 예외 처리
              }
            },
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
        "알림함",
        style: TextStyle(
            color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}

Widget requestMsgBox(String name, String thumbnailUrl, String title,
    String introLine, int boardId) {
  ListDetailInfo listDetailInfo;

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
          print(jsonResults);
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
        likedBoard: false);
  }

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(children: [
      Row(children: [
        const Icon(Icons.handshake_outlined),
        Text(
          ' $name',
          style: TextStyle(
              color: CustomColor.grey5,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        )
      ]),
      const SizedBox(
        height: 8,
      ),
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
                        ),
                        Text(
                          introLine,
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(CustomColor.primary1),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await requestRecruitingDetail(boardId)
                              .then((listDetailInfo) {
                            Get.to(() => ListDetail(
                                intValue: boardId,
                                title: title,
                                nickname: listDetailInfo.nickName,
                                createdDate: 'createdDate',
                                thumbnailUrl: thumbnailUrl,
                                likes: listDetailInfo.likes,
                                views: listDetailInfo.views,
                                urls: listDetailInfo.imageUrls,
                                introLine: introLine,
                                likedBoard: listDetailInfo.likedBoard));
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.list_alt_outlined,
                                color: CustomColor.grey5),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '글 보러가기',
                              style: TextStyle(
                                  color: CustomColor.grey5,
                                  fontSize: 18,
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

Widget joinMsgBox(
    String name, String thumbnailUrl, String title, String introLine, int boardId) {
  ListDetailInfo listDetailInfo;

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
        likedBoard: false);
  }
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(children: [
      Row(children: [
        Icon(Icons.how_to_vote_outlined),
        Text(
          ' $name',
          style: TextStyle(
              color: CustomColor.grey5,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        )
      ]),
      const SizedBox(
        height: 8,
      ),
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
                        ),
                        Text(
                          introLine,
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )
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
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await requestRecruitingDetail(boardId)
                              .then((listDetailInfo) {
                            Get.to(() => ListDetail(
                                intValue: boardId,
                                title: title,
                                nickname: listDetailInfo.nickName,
                                createdDate: 'createdDate',
                                thumbnailUrl: thumbnailUrl,
                                likes: listDetailInfo.likes,
                                views: listDetailInfo.views,
                                urls: listDetailInfo.imageUrls,
                                introLine: introLine,
                                likedBoard: listDetailInfo.likedBoard));
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.list_alt_outlined,
                                color: CustomColor.grey5),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '글 보러가기',
                              style: TextStyle(
                                  color: CustomColor.grey5,
                                  fontSize: 18,
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

Widget startMsgBox(String name, String thumbnailUrl, String title,
    String introLine, String appLink, String webLink, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(children: [
      Row(
        children: [
          Icon(
            Icons.play_arrow_outlined,
          ),
          const SizedBox(width: 8), // 아이콘과 텍스트 간격 조절
          Expanded(
            child: Text(
              '${name.contains('.') ? name.replaceAll('.', '.\n') : name}',
              style: TextStyle(
                color: CustomColor.grey5,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2, // 최대 두 줄까지 표시
              overflow: TextOverflow.ellipsis, // 오버플로우 된 경우 '...'으로 표시
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 8,
      ),
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
                        ),
                        Text(
                          introLine,
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(CustomColor.primary1),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      onPressed: ()  async{
                        Uri uri = Uri.parse(appLink);
                        bool isOpen = await openLink(uri);
                        if(!isOpen){
                          Common().showToastN(context, '$appLink를 열 수 없습니다', 1);
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.phonelink_ring_outlined,
                            color: CustomColor.grey5,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '앱 링크',
                            style: TextStyle(
                                color: CustomColor.grey5,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                        // backgroundColor:
                        // MaterialStateProperty.all(CustomColor.primary1),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(
                                color: CustomColor.primary1), // 여기에 테두리 색 지정
                          ),
                        ),
                      ),
                      onPressed: () async {
                        Uri uri = Uri.parse(webLink);
                        bool isOpen = await openLink(uri);
                        if(!isOpen){
                          Common().showToastN(context, '$webLink를 열 수 없습니다', 1);
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.phonelink_outlined,
                            color: CustomColor.grey5,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '웹 링크',
                            style: TextStyle(
                                color: CustomColor.grey5,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    ]),
  );
}
Widget endUploaderBox(String name, String thumbnailUrl, String title,
    String introLine,int boardId, BuildContext context) {

  void requestTestEndBroadCast(int boardId) async {
    try {
      String url = '${Common.url}boards/${boardId.toString()}/end';
      String? bearerToken = await FirebaseAuth.instance.currentUser!.getIdToken();

      var data = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $bearerToken',
        },
      );

      if (data.statusCode == 200) {
        print('Test end broadcast successful');
      } else {
        print('Failed to end test broadcast. Status code: ${data.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(children: [
      Row(children: [
        const Icon(Icons.cloud_done_outlined),
        Text(
          ' $name',
          style: TextStyle(
              color: CustomColor.grey5,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        )
      ]),
      const SizedBox(
        height: 8,
      ),
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
                        ),
                        Text(
                          introLine,
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )
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
                          MaterialStateProperty.all(CustomColor.primary2),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          requestTestEndBroadCast(boardId);
                          Common().showToastN(context, '테스트가 종료되었습니다!', 1);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.done,
                              color: CustomColor.primary1,
                              size: 25,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '테스트 종료하기',
                              style: TextStyle(
                                  color: CustomColor.primary1,
                                  fontSize: 18,
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

Widget endTesterBox(String name, String thumbnailUrl, String title,
    String introLine, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(children: [
      Row(children: [
        const Icon(Icons.cloud_done_outlined),
        Text(
          ' $name',
          style: TextStyle(
              color: CustomColor.grey5,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        )
      ]),
      const SizedBox(
        height: 8,
      ),
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
                        ),
                        Text(
                          introLine,
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )
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
                              MaterialStateProperty.all(CustomColor.primary2),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Common().showToastN(context, '테스트가 완료되었습니다!', 1);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.done,
                              color: CustomColor.primary1,
                              size: 25,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '테스트 종료',
                              style: TextStyle(
                                  color: CustomColor.primary1,
                                  fontSize: 18,
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

Future<bool> openLink(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
    return true;
  } else {
    print('Could not launch $url');
    return false;
  }
}