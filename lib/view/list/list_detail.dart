import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utility/common.dart';

class ListDetail extends StatefulWidget {
  final int intValue;
  final String title;
  final String nickname;
  final String createdDate;
  final String thumbnailUrl;

  const ListDetail({
    Key? key,
    required this.intValue,
    required this.title,
    required this.nickname,
    required this.createdDate,
    required this.thumbnailUrl,
  }) : super(key: key);

  @override
  State<ListDetail> createState() => _ListDetailState();
}

class _ListDetailState extends State<ListDetail> {
  String content = '';
  List<dynamic> urls = [];
  int participantNum = 0;
  TextEditingController emailController = TextEditingController();

  bool isWaiting = true;

  Future<void> requestRecruitingDetail() async {
    try {
      String url = "${Common.url}boards/${widget.intValue}";
      String? bearerToken =
          await FirebaseAuth.instance.currentUser!.getIdToken();

      var data = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $bearerToken',
        },
      );

      if (data.statusCode == 200) {
        if (data.body.isNotEmpty) {
          var jsonResults = jsonDecode(utf8.decode(data.bodyBytes));

          content = jsonResults["content"];
          urls = jsonResults["imageUrls"];
          participantNum = jsonResults["participantNum"];
        }
      } else {
        print("Status code: ${data.statusCode}");
        print("Response body: ${data.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void _showEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("이메일 제출하기", style: TextStyle(fontSize:18 ,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
              ),
              const Text(
                "하단에 Email란에 메일을 적어주시면\n작성자 확인 후 테스트 링크를 보내드립니다.",
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: '이메일 입력하기',
                    filled: true,
                    fillColor: Colors.black12, // 바탕색 설정
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                ),
              ),
              const Divider(height: 2, thickness: 1),
              TextButton(
                onPressed: () {
                  // '제출하기' 버튼
                  String userEmail = emailController.text;
                  // 여기에서 userEmail을 사용하여 작성자 확인 및 테스트 링크 전송 로직을 추가할 수 있습니다.
                  print("이메일 제출: $userEmail");
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  emailController.clear();
                },
                child: Text(
                  '제출하기',
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ),
              const Divider(height: 2, thickness: 1),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 취소 버튼
                  emailController.clear();
                },
                child: Text(
                  '취소',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose(){
    emailController.dispose();
  }

  init() async {
    await requestRecruitingDetail();
    setState(() {
      isWaiting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appIcon(widget.thumbnailUrl),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12.0, 12.0, 6.0),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 12.0, 0),
                      child: Text(content,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16)),
                    ),

                    /// threeTitle(),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6.0, 12.0, 0),
                      child: Row(
                        children: [
                          Image.asset("assets/icons/personIcon.png"),
                          Text(
                            " $participantNum / 20명",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6.0, 12.0, 12.0),
                      child: Text(
                        "진행률 ${(participantNum / 20).toStringAsFixed(1)}%",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                    LinearProgressIndicator(
                      value: participantNum / 20,
                      backgroundColor: Colors.black12, // 배경색
                      valueColor: AlwaysStoppedAnimation<Color>(
                          CustomColor.pointColor), // 진행률 바 색상
                      minHeight: 10,
                    ),

                    /// imageList(),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _showEmailDialog();
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
                        Icon(
                          Icons.link_outlined,
                          color: Colors.white,
                          size: 40,
                        ),
                        // 아이콘 색상 설정
                        SizedBox(width: 8.0),
                        // 아이콘과 텍스트 사이의 간격 조절
                        Text(
                          "참여하기",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        // 글자색 설정
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget appIcon(String thumbnailUrl) {
    return SizedBox(
      height: 80,
      width: 80,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: CachedNetworkImage(
          fit: BoxFit.fill,
          imageUrl: thumbnailUrl,
        ),
      ),
    );
  }

  Widget threeTitle(String nickname, String heart, String views) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Text(nickname),
          SizedBox(width: 16),
          Icon(Icons.favorite_border_outlined, color: Colors.red), // Heart icon
          Text(" $heart"),
          SizedBox(width: 16),
          Icon(Icons.visibility_outlined), // View count icon
          // Text("$viewCount"), // View coun
          Text(' $views')
        ],
      ),
    );
  }

  Widget imageList(List<String> urls) {
    return ListView.builder(
      itemCount: urls.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: CachedNetworkImage(
            imageUrl: urls[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
