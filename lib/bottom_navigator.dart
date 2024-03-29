import 'package:and20roid/utility/common.dart';
import 'package:and20roid/controller/list_controller.dart';
import 'package:and20roid/view/list/list_page.dart';
import 'package:and20roid/controller/my_page_controller.dart';
import 'package:and20roid/view/ranking/rank_page.dart';
import 'package:and20roid/view/alarm/notification_page.dart';
import 'package:and20roid/controller/ranking_controller.dart';
import 'package:and20roid/view/upload/upload_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controller/notification_controller.dart';
import 'view/mypage/another_mypage.dart';
import 'view/mypage/my_page.dart';

class BottomNavigatorPage extends StatefulWidget {
  final int? initialValue;
  const BottomNavigatorPage({Key? key, this.initialValue}) : super(key: key);

  @override
  State<BottomNavigatorPage> createState() => _BottomNavigatorPageState();
}

class _BottomNavigatorPageState extends State<BottomNavigatorPage> {
  @override
  void initState() {
    setState(() {
      if(widget.initialValue != null){
        _currentIndex = widget.initialValue!;
      }
    });
    super.initState();
  }

  int _currentIndex = 0;
  FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;

  void logScreenView(String screenName) {
    firebaseAnalytics.logEvent(
      name: 'screen_view',
      parameters: {'screen_name': screenName},
    );
  }

  final notiCtrl = Get.find<NotiController>();
  final rankCtrl = Get.find<RankingController>();
  final listCtrl = Get.find<ListController>();
  final myCtrl = Get.find<MyPageControllrer>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        bool value = await someFunction();
        if (value) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: SafeArea(child: _buildPage(_currentIndex)),
        bottomNavigationBar: Stack(children: [
          BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: CustomColor.grey5,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  size: 25,
                ),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.emoji_events_outlined,
                  size: 25,
                ),
                label: '랭킹',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_box_outlined,
                  size: 25,
                ),
                label: '업로드',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.notifications_none_outlined,
                  size: 25,
                ),
                label: '알림함',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outlined,
                  size: 25,
                ),
                label: '내 정보',
              ),
            ],
            onTap: (index) {
              if (index == 0) {
                listCtrl.gotoTop();
                listCtrl.update();
                logScreenView('홈');
              } else if (index == 1) {
                rankCtrl.requestTotalRanking();
                print('ranking update ');
                rankCtrl.update();
                logScreenView('랭킹');
              } else if (index == 2) {
                logScreenView('업로드');
              } else if (index == 3) {
                notiCtrl.requestUserTestNum();
                notiCtrl.alarmCount = 0.obs;
                logScreenView('알림');
              } else if (index == 4) {
                myCtrl.getUserName();
                myCtrl.update();
                logScreenView('마이페이지');
              }
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          Obx(() => alarmCount(notiCtrl.alarmCount.value.toString())),
        ]),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return ListContent(); // 목록 페이지
      case 1:
        // return RequestTest(userName: 'test', ranking: '1', helpEach: 1, related: true,); // 랭킹 페이지
        return RankingContent(); // 랭킹 페이지
      case 2:
        return UploadView(); // 업로드 페이지
      case 3:
        return NotificationContent(); // 알림 페이지
      case 4:
        return MyPageContent(); // 마이페이지
      default:
        return ListContent();
    }
  }

  Widget alarmCount(String count) {
    return Positioned(
      right: count.length > 1
          ? MediaQuery.of(context).size.width / 5 * 1.2
          : MediaQuery.of(context).size.width / 5 * 1.26,
      top: 0,
      child: (count == '0')
          ? Container()
          : Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red, // 원하는 색상
              ),
              child: Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  Future<bool> someFunction() async {
    bool? confirmExit = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(dialogBackgroundColor: Colors.white),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: context.width,
                  color: CustomColor.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                    child: Text(
                      '앱을 종료하시겠습니까?',
                      style: TextStyle(
                          fontSize: 20,
                          color: CustomColor.grey5,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(CustomColor.grey2),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all(
                              Size(double.infinity, 50)), //
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false); // Cancel exit
                        },
                        child: Text(
                          '취소',
                          style: TextStyle(
                            color: CustomColor.grey4,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(CustomColor.primary1),
                          minimumSize: MaterialStateProperty.all(
                              Size(double.infinity, 50)), //
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ), // 꽉 차게 하기 위한 설정
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true); // Confirm exit
                        },
                        child: Text(
                          '종료하기',
                          style: TextStyle(
                            color: CustomColor.grey5,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );

    return confirmExit ??
        false; // Return false by default if confirmExit is null
  }
}
