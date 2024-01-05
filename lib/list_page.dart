import 'package:flutter/material.dart';

import 'common.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final SaveSharedPreferences sharedPreferences = SaveSharedPreferences();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder<String>(
            future: sharedPreferences.getUserNick(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                String userNick = snapshot.data ?? "";
                return Text('User Nick: $userNick');
              }
            },
          ),
        ],
      ),
    );
  }
}
