import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../model/list_model.dart';
import '../utility/common.dart';

class ListContent extends StatelessWidget {
  final List<GatherList> gatherListItems = []; // `fromJson`으로 받은 데이터를 저장할 리스트

  Future<List<GatherList>> requestRecruitingList() async {
    try {
      String url = "${Common.url}boards";
      Map<String, dynamic> body = {};

      var data = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (data.statusCode == 200) {
        if (data.body.isNotEmpty) {
          var jsonResults = jsonDecode(utf8.decode(data.bodyBytes));
          print(jsonResults.toString());
          print(jsonEncode(jsonResults));

          // jsonResults를 순회하며 GatherList 인스턴스로 변환하여 gatherListItems에 추가
          for (var jsonResult in jsonResults) {
            GatherList gatherList = GatherList.fromJson(jsonResult);
            gatherListItems.add(gatherList);
          }

          print("~~~~~~~Success Get Recruit List request");
          // 성공적으로 처리된 경우 gatherListItems 반환
          return gatherListItems;
        }
      }

      print("~~~~~~~~~~fail Get Recruit List request");
      print("Status code: ${data.statusCode}");
      print("Response body: ${data.body}");
    } catch (e) {
      // 예외 처리
      print('Error: $e');
    }
    // 실패한 경우 또는 예외 발생한 경우 null 반환
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: gatherListItems.isEmpty
          ? Skeletonizer(
          enabled: true,
          child: ListView.builder(
            itemCount: 6,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text('Item number $index as title'),
                  subtitle: const Text('Subtitle here'),
                  trailing: const Icon(
                    Icons.ac_unit,
                    size: 32,
                  ),
                ),
              );
            },
          ),)
          : Column(
              children: [
                Expanded(
                  child: Skeletonizer(
                    enabled: false,
                    child: ListView.builder(

                      itemCount: gatherListItems.length,
                      // 리스트 아이템 개수는 `fromJson`으로 받은 데이터의 개수와 동일하게 설정
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: SizedBox(
                            height: 80,
                            width: 60,
                            child: Image.network(gatherListItems[index]
                                .imageUrl), // 이미지 URL을 사용하여 이미지 표시
                          ),
                          title: Text(gatherListItems[index].title), // 제목 표시
                          subtitle: Text(gatherListItems[index].auth), // 작성자 표시
                          trailing: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person),
                                  Text(
                                      "${gatherListItems[index].currentTester}/20")
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.timelapse),
                                  Text("${gatherListItems[index].date}")
                                ],
                              ),
                            ],
                          ),
                          // Add any other properties or functionalities for each list item
                        );
                      },
                    ),
                  ),
                ),

                // Any widgets you want below the list
                Text('Below the List'),
              ],
            ),
    );
  }
}
