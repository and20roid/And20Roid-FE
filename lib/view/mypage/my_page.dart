import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utility/common.dart';
import 'another_mypage.dart';

class MyPageContent extends StatelessWidget {
  final SaveSharedPreferences sharedPreferences = SaveSharedPreferences();

  Future<String> _getUserName() async {
    return await sharedPreferences.getUserNick();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          String name = snapshot.data ?? "";
          return Scaffold(
            body: RequestTest(userName: name),
          );
        } else {
          return CircularProgressIndicator(); // or any loading indicator
        }
      },
    );
  }
}
