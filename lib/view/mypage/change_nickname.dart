import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../utility/common.dart';

class ChangeNickname extends StatelessWidget {
  const ChangeNickname({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColor.grey1,
        appBar: _appBar(),
        body: _body(context),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: CustomColor.grey1,
      title: Text(
        "닉네임 변경",
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _body(context) {
    TextEditingController textEditingController = TextEditingController();

    Future<bool> requestUpdateNickname(String nickName) async {
      try {
        String url = '${Common.url}users';
        String? bearerToken =
            await FirebaseAuth.instance.currentUser!.getIdToken();

        var data = await http.put(Uri.parse(url),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $bearerToken',
            },
            body: jsonEncode({
              "nickname": nickName,
            }));

        if (data.statusCode == 200) {
          print('update success');
          return true;
        }
      } catch (e) {
        // Handle exceptions here
        print('Error: $e');
      }
      return false;
    }

    return Column(
      children: [
        CustomInputField('닉네임 입력', textEditingController, '변경할 닉네임을 입력해 주세요'),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () async {
                  bool isSuccess = await requestUpdateNickname(textEditingController.text);
                  if(isSuccess){
                    Common().showToastN(context, '닉네임이 성공적으로 변경됐습니다', 1);
                    Get.back();
                  }
                  else{
                    Common().showToastN(context, '닉네임 변경에 실패했습니다', 1);
                  }
                },
                child: Text(
                  "변경하기",
                  style: TextStyle(fontSize: 18, color: CustomColor.grey5),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(CustomColor.primary1),
                  minimumSize: MaterialStateProperty.all(Size(80, 50)),
                  maximumSize: MaterialStateProperty.all(Size(120, 80)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Widget CustomInputField(
      title, TextEditingController testController, hintText) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: testController,
            style: TextStyle(fontSize: 16, color: CustomColor.grey5),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: CustomColor.grey1, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                // 포커스가 있을 때의 테두리 설정
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: CustomColor.primary1, width: 1),
              ),
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
