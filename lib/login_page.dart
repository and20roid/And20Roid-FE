import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

import 'join_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("로그인"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await signInWithGoogle();
            } catch (e) {
              print('Google Sign-In Error: $e');
            }
          },
          child: const Text("Gmail로 로그인"),
        ),
      ),
    );
  }
  Future<void> signInWithGoogle() async {
    try {
      // Google 로그인
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        // 사용자가 Google 로그인을 취소한 경우
        return;
      }

      // Google 로그인에서 얻은 인증 정보
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      // Firebase에 사용할 수 있는 AuthCredential 생성
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Firebase에 Google 사용자로 로그인
      await _auth.signInWithCredential(credential);

      // 로그인 성공 후 다음 화면으로 이동
      Get.to(() => const JoinPage());
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
