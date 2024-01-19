import 'package:and20roid/view/list/list_page.dart';
import 'package:and20roid/view/ranking/rank_page.dart';
import 'package:and20roid/view/notification_page.dart';
import 'package:and20roid/view/upload/upload_page.dart';
import 'package:flutter/material.dart';
import 'view/mypage/my_page.dart';

class BottomNavigatorPage extends StatefulWidget {
  const BottomNavigatorPage({Key? key}) : super(key: key);

  @override
  State<BottomNavigatorPage> createState() => _BottomNavigatorPageState();
}

class _BottomNavigatorPageState extends State<BottomNavigatorPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildPage(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset("assets/icons/Vector.png"),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/icons/Vector-1.png"),
              label: '랭킹',
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/icons/Vector-2.png"),
              label: '업로드',
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/icons/Vector-3.png"),
              label: '알림',
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/icons/Vector-4.png"),
              label: '마이페이지',
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
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
}






