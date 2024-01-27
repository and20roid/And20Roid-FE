import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skeletonizer/skeletonizer.dart';

import '../../utility/common.dart';

class ListDetail extends StatefulWidget {
  final int intValue;
  final String title;
  final String nickname;
  final String createdDate;
  final String thumbnailUrl;
  final int likes;
  final int views;
  final List<String> urls;
  final String introLine;
  final bool likedBoard;

  const ListDetail({
    Key? key,
    required this.intValue,
    required this.title,
    required this.nickname,
    required this.createdDate,
    required this.thumbnailUrl,
    required this.likes,
    required this.views,
    required this.urls,
    required this.introLine,
    required this.likedBoard,
  }) : super(key: key);

  @override
  State<ListDetail> createState() => _ListDetailState();
}

class _ListDetailState extends State<ListDetail> {
  String content = '';
  int participantNum = 0;
  TextEditingController emailController = TextEditingController();
  bool isWaiting = true;
  final _formKey = GlobalKey<FormState>();

  late bool isLiked = widget.likedBoard;

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

  Future<void> requestClickPartButton(String email) async {
    try {
      String url = "${Common.url}participation";
      String? bearerToken =
          await FirebaseAuth.instance.currentUser!.getIdToken();

      var _body = {"boardId": widget.intValue, "email": email};
      var data = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode(_body),
      );

      if (data.statusCode == 200) {
        Common().showToastN(context,'이메일을 성공적으로 전송했습니다',1);
      } else {
        Map<String, dynamic> parsedResponse = jsonDecode(utf8.decode(data.bodyBytes));
        String message = parsedResponse['message'];

        if(data.statusCode == 400 ){
          Common().showToastN(context,message,1);
        }
        print("Response body: ${utf8.decode(data.bodyBytes)}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> requestClickHeartButton() async {
    try {
      String url = "${Common.url}boards/${widget.intValue}/likes";
      String? bearerToken =
          await FirebaseAuth.instance.currentUser!.getIdToken();

      var _body = {"boardId": widget.intValue};
      var data = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode(_body),
      );

      if (data.statusCode == 200) {
        print("좋아요 요청 성공");
        print(data.body.toString());
        if (data.body.toString() == "좋아요") {
          setState(() {
            isLiked = true;
          });
        } else {
          setState(() {
            isLiked = false;
          });
        }
      } else {
        print("Status code: ${data.statusCode}");
        print("Response body: ${data.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: Colors.white,
          ),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                  child: Text(
                    "이메일 전송하기",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Text(
                  "하단에 Email란에 메일을 적어주시면\n작성자 확인 후 테스트 링크를 보내드립니다.",
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      validator: validateEmail,
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: '이메일 입력하기',
                        filled: true,
                        fillColor: CustomColor.grey2,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        contentPadding: const EdgeInsets.all(12.0),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // 취소 버튼
                          emailController.clear();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(CustomColor.white),
                          minimumSize:
                          MaterialStateProperty.all(const Size(135, 40)),
                          side: MaterialStateProperty.all(
                            BorderSide(color: CustomColor.grey3, width: 1.0),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        child: Text(
                          '취소',
                          style: TextStyle(
                            color: CustomColor.grey3,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(CustomColor.primary1),
                          minimumSize:
                          MaterialStateProperty.all(Size(135, 40)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            print('----------------------------유효함');
                            String userEmail = emailController.text;
                            requestClickPartButton(userEmail);
                            Navigator.of(context).pop();
                            emailController.clear();
                          }
                        },
                        child: Text(
                          '전송',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
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
  void dispose() {
    emailController.dispose();
    super.dispose();
  }


  init() async {
    await requestRecruitingDetail();
    setState(() {
      isWaiting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColor.grey1,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: SingleChildScrollView(
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
                        child: Text(widget.introLine,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16)),
                      ),
                      threeTitle(widget.nickname, widget.likes.toString(),
                          widget.views.toString()),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 6.0, 12.0, 12.0),
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
                      LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(4),
                        value: participantNum / 20,
                        backgroundColor: Colors.black12, // 배경색
                        valueColor: AlwaysStoppedAnimation<Color>(
                            CustomColor.primary1), // 진행률 바 색상
                        minHeight: 10,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      imageList(widget.urls, MediaQuery.of(context).size.width),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12.0, 0, 0),
                        child: Text(content,
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: CustomColor.primary2,
                ),
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  "$participantNum명의 테스터 참여 중",
                  style: TextStyle(
                      color: CustomColor.primary3,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () {
                  _showEmailDialog(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColor.primary1,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // 모서리 radius 설정
                    ),
                    minimumSize: const Size.fromHeight(60)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/icons/email.png"),
                    // 아이콘 색상 설정
                    const SizedBox(width: 8.0),
                    // 아이콘과 텍스트 사이의 간격 조절
                    const Text(
                      "참여하기",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    // 글자색 설정
                  ],
                ),
              ),
            )
          ],
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
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        children: [
          Text(nickname),
          SizedBox(width: 16),
          InkWell(
              onTap: () async {
                await requestClickHeartButton();
              },
              child: isLiked
                  ? Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.red),
                        Text(" ${(int.parse(heart)+1).toString()}"),
                      ],
                    )
                  : Row(
                      children: [
                        Icon(Icons.favorite_border_outlined, color: Colors.red),
                        Text(" $heart"),
                      ],
                    )),
          const SizedBox(width: 16),
          const Icon(Icons.visibility_outlined),
          Text(' $views')
        ],
      ),
    );
  }

  Widget imageList(List<String> urls, double screenWidth) {
    return Container(
      height: screenWidth / 1.6,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 12.0, 12.0, 0),
            child: SizedBox(
              width: screenWidth / 3.5, // 화면 너비의 3분의 1 크기로 설정
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: CustomColor.grey5, width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    imageUrl: urls[index],
                    fit: BoxFit.fill,
                  ),
                ),
              ),

            ),
          );
        },
      ),
    );
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? '올바른 이메일 형식을 입력해주세요'
        : null;
  }
}
