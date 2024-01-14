import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestTest extends StatelessWidget {
  final String userName;

  const RequestTest({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  '나와의 관계 : 테스트를 도와줬던 분',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: testInfo("테스트 진행 횟수", '7')),
                  SizedBox(width: 10,),
                  Expanded(child: testInfo("테스트 의뢰 횟수", '2')),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () {
                    print("touched");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CupertinoColors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // 모서리 radius 설정
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "테스트 요청하기",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      // 글자색 설정
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget testInfo(String title, String num) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.cyan
      ),
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 앞쪽 정렬 설정
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "$num회",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
          ],
        ));
  }
}
