import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../mypage/another_mypage.dart';

class RankingContent extends StatelessWidget {

  void movePage(String userName){
    Get.to(()=>RequestTest(userName: userName,));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Text('랭킹',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              Spacer()
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                trophy('2','seungw2n','100',"assets/images/Vector-1.png"),
                trophy('1','seungw1n','99',"assets/images/Vector.png"),
                trophy('3','seungw3n','98',"assets/images/Vector-2.png"),
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
                    return InkWell(
                      onTap: (){
                        movePage(playerName);
                      },
                      child: ListTile(
                        title: Text('$ranking등 $playerName'),
                        trailing: Text('$testCount회'),
                      ),
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

  Widget trophy(String ranking, String name, String count, String imagePath) {
    return InkWell(
      onTap: (){
        movePage(name);
      },
      child: Column(
        children: [
          (ranking == '1')?
          Container():const SizedBox(
            height: 60,
          ),
          Container(
            width: 50,
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Image.asset(imagePath),
          ),
          Text(
            "$ranking등\n$name\n$count회",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
