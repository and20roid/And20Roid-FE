import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'bottom_navigator.dart';
import 'view/login_page.dart';

class DirectingPage extends StatefulWidget {
  const DirectingPage({Key? key}) : super(key: key);

  @override
  _TmpPageState createState() => _TmpPageState();
}

class _TmpPageState extends State<DirectingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _permission();
    _auth();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _permission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }

  _auth() {
    // 사용자 인증정보 확인. 딜레이를 두어 확인
    Future.delayed(const Duration(milliseconds: 100), () async {
      if (FirebaseAuth.instance.currentUser == null) {
        Get.offAll(() => const LoginPage());
      } else {
        String jwt = await FirebaseAuth.instance.currentUser?.getIdToken() as String;
        print('firebase id Token : $jwt');
        Get.offAll(() => const BottomNavigatorPage());
      }
    });
  }
}
