import 'package:flutter/material.dart';

import '../../utility/common.dart';

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
      toolbarHeight: 80,
      backgroundColor: CustomColor.grey1,
      title: const Text(
        "내 정보 수정",
        style: TextStyle(
            color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _body() {
    return const Column(
      children: [
        ListTile(
          leading: Icon(Icons.near_me_outlined),
          title: Text("닉네임 변경"),
        ),
        ListTile(
          leading: Icon(Icons.logout_outlined),
          title: Text("로그 아웃"),
        ),
        ListTile(
          leading: Icon(Icons.outbond_outlined),
          title: Text("회원 탈퇴"),
        ),
        ListTile(
          leading: Icon(Icons.person_2_outlined),
          title: Text("개인정보 처리방침"),
        ),
      ],
    );
  }
}
