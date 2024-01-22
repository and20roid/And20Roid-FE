import 'package:and20roid/utility/common.dart';
import 'package:and20roid/view/list/list_page.dart';
import 'package:and20roid/view/ranking/rank_page.dart';
import 'package:and20roid/view/alarm/notification_page.dart';
import 'package:and20roid/view/ranking/ranking_controller.dart';
import 'package:and20roid/view/upload/upload_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/alarm/notification_controller.dart';
import 'view/mypage/my_page.dart';

class BottomNavigatorPage extends StatefulWidget {
  const BottomNavigatorPage({Key? key}) : super(key: key);

  @override
  State<BottomNavigatorPage> createState() => _BottomNavigatorPageState();
}

class _BottomNavigatorPageState extends State<BottomNavigatorPage> {
  int _currentIndex = 0;

  final notiCtrl = Get.find<NotiController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildPage(_currentIndex),
        bottomNavigationBar: Stack(children: [
          BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: CustomColor.grey5,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined,size: 25,),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events_outlined,size: 25,),
                label: '랭킹',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined,size: 25,),
                label: '업로드',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none_outlined,size: 25,),
                label: '알림함',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined,size: 25,),
                label: '내 정보',
              ),
            ],
            onTap: (index) {
              if(index == 3){
                notiCtrl.alarmCount = 0.obs;
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
      right: count.length > 1 ? MediaQuery.of(context).size.width / 5 * 1.2 : MediaQuery.of(context).size.width / 5 * 1.26,
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
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}
