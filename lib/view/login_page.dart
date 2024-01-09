import 'dart:convert';

import 'package:and20roid/utility/common.dart';
import 'package:and20roid/direct_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../bottom_navigator.dart';

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
        resizeToAvoidBottomInset: false,
        body: Container(
          color: MyColor.mainColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "And 20",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 150,
              ),
              Center(
                child: Column(
                  children: [
                    const Text(
                      "당신의 앱은 테스트가\n필요하니까",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 100),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await signInWithGoogle();
                        } catch (e) {
                          print('Google Sign-In Error: $e');
                        }
                      },
                      child: Text(
                        "Sign up with Google",
                        style: TextStyle(color: MyColor.mainColor),
                      ),
                    ),
                    const SizedBox(height: 200),
                    Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.bottomRight,
                      color: Colors.white,
                      child: Image.asset(
                        "assets/images/pngegg.png",
                        width: 40,
                        height: 40,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> requestSignup(String? token, String userNick) async {
    try {
      String url = "${Common.url}users/signup";
      Map<String, dynamic> body = {
        "token": token,
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
        if(data.body.isNotEmpty) {
          var jsonResults = jsonDecode(utf8.decode(data.bodyBytes));
          print(jsonResults.toString());
          print(jsonEncode(jsonResults));

        }

        print("~~~~~~~Success sign up request");
        // 성공적으로 처리된 경우
        return true;
      } else {
        print("~~~~~~~~~~fail sign up request");
        print("Status code: ${data.statusCode}");
        print("Response body: ${data.body}");
        // 실패한 경우
        return false;
      }
    } catch (e) {
      // 예외 처리
      print('Error: $e');
      return false;
    }
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

      sharedPreferences.getUserNick().then((value) => {
      print("`~~~~~~~~~~~저장된 유저 닉 : $value")
      });

      sharedPreferences.getUserToken().then((value) => {
        print("`~~~~~~~~~~~저장된 유저 token : $value")
      });

      _auth.currentUser?.getIdToken().then((token) {
        print("firebase token : $token");
      });

      String? uId = await sharedPreferences.getUserToken();

      //회원가입시 서버에 저장
      await requestSignup(uId, userNick);

      if(_auth.currentUser != null)
        {
          print("~~~~~~~~~null은 아니라서 넘어가유 ~");
          Get.offAll(() => const BottomNavigatorPage());
        }
      else{
        print("-----------------안넘어가유 ~");
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
