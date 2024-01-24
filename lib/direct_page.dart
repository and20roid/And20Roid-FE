import 'dart:convert';

import 'package:and20roid/utility/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bottom_navigator.dart';
import 'view/login_page.dart';
import 'package:http/http.dart' as http;

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
    _auth();
  }

  @override
  void dispose() {
    super.dispose();
  }


  Future<bool> _requestToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();
    print('~~~~~~~~~~~~~~~~~~token : $token');
    try {
      String url = "${Common.url}users/tokens";
      String? bearerToken =
          await FirebaseAuth.instance.currentUser!.getIdToken();

      Map<String, dynamic> body = {
        "token": token,
      };

      var data = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode(body),
      );

      if (data.statusCode == 200) {
        print('~~~~~~~~~~~~~~~~~~~~~~~~~~requestToken Success');
        return true;
      }
    } catch (e) {
      print('failed to _requestToken Exception =' + e.toString());
    }
    return false;
  }

  _auth() {
    // 사용자 인증정보 확인. 딜레이를 두어 확인
    Future.delayed(const Duration(milliseconds: 100), () async {
      if (FirebaseAuth.instance.currentUser == null) {
        Get.offAll(() => const LoginPage());
      } else {
        String jwt =
            await FirebaseAuth.instance.currentUser?.getIdToken() as String;
        print('firebase id Token : $jwt');
        _requestToken();
        Get.offAll(() => const BottomNavigatorPage());
      }
    });
  }


}
