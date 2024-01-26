import 'package:and20roid/direct_page.dart';
import 'package:and20roid/view/mypage/change_nickname.dart';
import 'package:and20roid/view/mypage/personal_info_processing_policy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import '../../utility/common.dart';
import 'my_page_controller.dart';

class ChangeInfo extends StatefulWidget {
  const ChangeInfo({super.key});

  @override
  State<ChangeInfo> createState() => _ChangeInfoState();
}

class _ChangeInfoState extends State<ChangeInfo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColor.grey1,
        appBar: _appBar(),
        body: _body(),
      ),
    );
  }

  AppBar _appBar() {
    final myCtrl = Get.find<MyPageControllrer>();

    return AppBar(
      toolbarHeight: 60,
      backgroundColor: CustomColor.grey1,
      title: const Text(
        "내 정보 수정",
        style: TextStyle(
            color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        onPressed: () {
          myCtrl.getUserName();
          Get.back();
        },
        icon: Icon(Icons.arrow_back_outlined),
      ),
    );
  }

  Widget _body() {
    Future<void> signOut() async {
      try {
        await FirebaseAuth.instance.signOut();
        print('User signed out successfully');
      } catch (e) {
        print('Error during sign out: $e');
      }
    }

    Future<void> deleteAccount() async {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // 사용자가 로그인되어 있으면 인증 세션 갱신
          await user.getIdToken(true);

          // 이후에 계정 삭제 수행
          await user.delete();

          print('Account deleted successfully');
        } else {
          print('No user is currently signed in');
        }
      } catch (e) {
        print('Error during account deletion: $e');
      }
    }

    Future<void> deleteDb() async {
      final url = Uri.parse('${Common.url}users');
      String? bearerToken =
          await FirebaseAuth.instance.currentUser!.getIdToken();
      try {
        final response = await http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $bearerToken', // 토큰을 헤더에 포함
          },
        );

        if (response.statusCode == 200) {
          print('Token deletion successful');
        } else {
          print('Token deletion failed. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Error during token deletion: $e');
      }
    }

    Future<void> deleteToken() async {
      final url = Uri.parse('${Common.url}users/tokens');
      String? bearerToken =
          await FirebaseAuth.instance.currentUser!.getIdToken();
      try {
        final response = await http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $bearerToken', // 토큰을 헤더에 포함
          },
        );

        if (response.statusCode == 200) {
          print('Token deletion successful');
        } else {
          print('Token deletion failed. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Error during token deletion: $e');
      }
    }

    Future<bool> logout(context) async {
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
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                      child: Text(
                        '로그아웃 하시겠습니까?',
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
                            '로그아웃',
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

    Future<bool> delete(context) async {
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
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                      child: Text(
                        '계정 탈퇴 하시겠습니까?',
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
                            '삭제하기',
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

    return Column(
      children: [
        ListTile(
          onTap: () {
            Get.to(() => ChangeNickname(), transition: Transition.rightToLeft);
          },
          leading: Icon(Icons.edit_outlined),
          title: Text("닉네임 변경"),
        ),
        ListTile(
          onTap: () async {
            bool confirmDeletion = await logout(context);
            if (confirmDeletion) {
              print('Account deleted');
              //firebase logout
              signOut();
              Common().showToastN(context, '잠시 후 앱이 재시작됩니다', 1);
              await Future.delayed(Duration(seconds: 5));
              Get.offAll(() => DirectingPage());
            } else {
              print('Deletion canceled');
            }
          },
          leading: Icon(Icons.logout_outlined),
          title: Text("로그 아웃"),
        ),
        ListTile(
          onTap: () async {
            bool confirmDeletion = await delete(context);
            if (confirmDeletion) {
              print('Account deleted');
              //firebase 계정 삭제
              deleteAccount();
              deleteDb();
              deleteToken();
              Common().showToastN(context, '잠시 후 앱이 종료됩니다', 1);
              await Future.delayed(Duration(seconds: 5));
              SystemNavigator.pop();
            } else {
              print('Deletion canceled');
            }
          },
          leading: Icon(Icons.no_accounts_outlined),
          title: Text("회원 탈퇴"),
        ),
        ListTile(
          onTap: () {
            Get.to(() => PersonalInfoProccessingPolicy(),
                transition: Transition.rightToLeft);
          },
          leading: Icon(Icons.person_2_outlined),
          title: Text("개인정보 처리방침"),
        ),
      ],
    );
  }
}
