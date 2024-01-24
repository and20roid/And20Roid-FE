import 'package:and20roid/view/mypage/change_nickname.dart';
import 'package:and20roid/view/mypage/delete_account.dart';
import 'package:and20roid/view/mypage/personal_info_processing_policy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/common.dart';
import 'logout.dart';

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
    return AppBar(
      toolbarHeight: 60,
      backgroundColor: CustomColor.grey1,
      title: const Text(
        "내 정보 수정",
        style: TextStyle(
            color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        ListTile(
          onTap: (){
            Get.to(()=>ChangeNickname(),transition: Transition.rightToLeft);
          },
          leading: Icon(Icons.edit_outlined),
          title: Text("닉네임 변경"),
        ),
        ListTile(
          onTap: (){
            Get.to(()=>Logout(),transition: Transition.rightToLeft);
          },
          leading: Icon(Icons.logout_outlined),
          title: Text("로그 아웃"),
        ),
        ListTile(
          onTap: (){
            Get.to(()=>DeleteAccount(),transition: Transition.rightToLeft);
          },
          leading: Icon(Icons.no_accounts_outlined),
          title: Text("회원 탈퇴"),
        ),
        ListTile(
          onTap: (){
            Get.to(()=>PersonalInfoProccessingPolicy(),transition: Transition.rightToLeft);
          },
          leading: Icon(Icons.person_2_outlined),
          title: Text("개인정보 처리방침"),
        ),
      ],
    );
  }
}
