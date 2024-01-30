import 'dart:convert';

import 'package:and20roid/utility/common.dart';
import 'package:and20roid/direct_page.dart';
import 'package:and20roid/view/alarm/notification_controller.dart';
import 'package:and20roid/view/ranking/ranking_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../bottom_navigator.dart';
import 'list/list_controller.dart';
import 'mypage/my_page_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SaveSharedPreferences sharedPreferences = SaveSharedPreferences();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColor.grey1,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            logo(),
            loginButton(),
          ],
        ),
      ),
    );
  }

  Widget loginButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(CustomColor.white),
          minimumSize: MaterialStateProperty.all(Size(310, 56)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(color: CustomColor.grey4),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        onPressed: () async {
          try {
            await signInWithGoogle();
          } catch (e) {
            print(e);
            Common().showToastN(context, e.toString(), 1);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/googlelogo.png'),
            const Text(
              "구글 계정으로 로그인",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
            Container(
              width: 32,
              height: 32,
              color: Colors.transparent, // 배경 색을 투명하게 설정
            )
          ],
        ),
      ),
    );
  }

  Widget logo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 140,
          width: 140,
          decoration: BoxDecoration(
            color: CustomColor.grey1,
            borderRadius: BorderRadius.circular(24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset('assets/images/logoNoback.png'),
          ),
        ),
        slogan(),
      ],
    );
  }

  Widget slogan() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 24,
            color: CustomColor.grey5,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: '안',
              style: TextStyle(color: CustomColor.primary1),
            ),
            TextSpan(text: '드로이드\n'),
            TextSpan(
              text: '단',
              style: TextStyle(color: CustomColor.primary1),
            ),
            TextSpan(text: '숨에 20명\n'),
            TextSpan(
              text: '테',
              style: TextStyle(color: CustomColor.primary1),
            ),
            TextSpan(text: '스터 모집'),
          ],
        ),
      ),
    );
  }

  Future<bool> requestSignup(String? token, String userNick) async {
    try {
      String url = "${Common.url}users/signup";
      Map<String, dynamic> body = {
        "uid": token,
        "nickname": userNick,
      };

      var data = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      if (data.statusCode == 200) {
        if (data.body.isNotEmpty) {
          var jsonResults = jsonDecode(utf8.decode(data.bodyBytes));
          print(jsonResults.toString());
          print(jsonEncode(jsonResults));
        }

        print("~~~~~~~Success sign up request");
        // 성공적으로 처리된 경우
        return true;
      } else {
        Map<String, dynamic> parsedResponse =
            jsonDecode(utf8.decode(data.bodyBytes));
        String message = parsedResponse['message'];
        print("~~~~~~~~~~fail sign up request");
        print("Status code: ${data.statusCode}");
        print("Response message: ${message}");
        // 실패한 경우
        return false;
      }
    } catch (e) {
      // 예외 처리
      print('Error: $e');
      return false;
    }
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

  Future<void> signInWithGoogle() async {
    try {
      // Google 로그인
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        // 사용자가 Google 로그인을 취소한 경우
        return;
      }
      // Google 로그인에서 얻은 인증 정보
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // 사용자의 이메일 앞부분 추출
      final String userEmail = googleSignInAccount.email;
      int atIdx = userEmail.indexOf("@");
      String userNick = userEmail.substring(0, atIdx);

      print("~~~~~~~~~~user Nick : $userNick");

      // Firebase에 사용할 수 있는 AuthCredential 생성
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Firebase에 Google 사용자로 로그인
      await _auth.signInWithCredential(credential);

      print('~~~~~~~~~~~구글 로그인 완료');

      sharedPreferences.setUserToken(_auth.currentUser!.uid);
      sharedPreferences.setUserNick(userNick);

      sharedPreferences
          .getUserNick()
          .then((value) => {print("~~~~~~~~~~~저장된 유저 닉 : $value")});

      sharedPreferences
          .getUserToken()
          .then((value) => {print("~~~~~~~~~~~저장된 유저 token : $value")});

      _auth.currentUser?.getIdToken().then((token) {
        print("firebase token : $token");
      });

      String? uId = _auth.currentUser!.uid;
      print("uid : $uId");

      //회원가입시 서버에 저장
      await requestSignup(uId, userNick);

      if (_auth.currentUser != null) {
        print('-------------controller loading--------------------');
        Get.put(ListController());
        Get.put(RankingController());
        Get.put(MyPageControllrer());
        Get.put(NotiController());

        print('-------------controller load success--------------------');
        await _requestToken();
        Get.offAll(() => const BottomNavigatorPage());
      } else {
        Get.offAll(() => const DirectingPage());
        print("-----------------다시 다이렉트 페이지로");
      }
    } on FirebaseAuthException catch (e) {
      // FirebaseAuthException 예외 발생 시 처리
      print('Firebase Authentication Error: $e');
      throw e;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
