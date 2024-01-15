import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utility/common.dart';
import 'another_mypage.dart';

class MyPageContent extends StatefulWidget {
  @override
  State<MyPageContent> createState() => _MyPageContentState();
}

class _MyPageContentState extends State<MyPageContent> {
  final SaveSharedPreferences sharedPreferences = SaveSharedPreferences();

  String? name;

  Future<void> _getUserName() async {
    name = await sharedPreferences.getUserNick();
    setState(() {});
  }

  @override
  void initState() {
    _getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: RequestTest(userName: name!,userId: 1,)
    ));
  }
}
