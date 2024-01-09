import 'package:flutter/material.dart';

class RankingContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('테스트에 도움 주신 분', style: TextStyle(fontSize: 30)),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Trophy Placeholder for 2nd Place
                Container(
                  width: 50,
                  height: 100,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                      size : 50,
                      Icons.emoji_events_outlined, color: Colors.grey),
                ),
                // Trophy Placeholder for 1st Place
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 100,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          size : 50,
                          Icons.emoji_events_outlined,
                          color: Colors.amber,
                        ),
                      ),
                      Text("이번 달 최다 테스트 : 멋남 님")
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  height: 100,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    size : 50,
                    Icons.emoji_events_outlined,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                color: Colors.grey[200], // Background color for the ListView
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    String playerName = '김숙희';
                    int ranking = index + 4;
                    int testCount =
                        10; // Replace this with the actual test count

                    return ListTile(
                      title: Text('$ranking등 $playerName'),
                      trailing: Text('$testCount회'),
                    );
                  },
                  itemCount:
                      5, // Replace this with the actual number of items in your list
                )),
          ),
        ],
      ),
    );
  }
}
