import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../utility/common.dart';

class NotificationContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        color: CustomColor.grey1,
        child: SingleChildScrollView(
          child: Column(
            children: [
              requestMsgBox(
                  '{닉네임}',
                  'https://and20roid-s3-bucket.s3.ap-northeast-2.amazonaws.com/0252baf4-dafe-4656-8f35-f8619d950092.jpeg',
                  'title',
                  'introLine'),
              joinMsgBox(
                  '{닉네임}',
                  'https://and20roid-s3-bucket.s3.ap-northeast-2.amazonaws.com/0252baf4-dafe-4656-8f35-f8619d950092.jpeg',
                  'title',
                  'introLine'),
              startMsgBox(
                  '{글 제목} 테스트가 시작됐어요',
                  'https://and20roid-s3-bucket.s3.ap-northeast-2.amazonaws.com/0252baf4-dafe-4656-8f35-f8619d950092.jpeg',
                  'title',
                  'introLine'),
              endMsgBox(
                  '{글 제목} 테스트가 종료되었어요.',
                  'https://and20roid-s3-bucket.s3.ap-northeast-2.amazonaws.com/0252baf4-dafe-4656-8f35-f8619d950092.jpeg',
                  'title',
                  'introLine'),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: CustomColor.grey1,
      title: const Text(
        "알림함",
        style: TextStyle(
            color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}

Widget requestMsgBox(
    String name, String thumbnailUrl, String title, String introLine) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(children: [
      Row(children: [
        Image.asset('assets/icons/handshake.png'),
        Text(
          ' $name님이 테스트를 요청했어요',
          style: TextStyle(
              color: CustomColor.grey5,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        )
      ]),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  appIcon(thumbnailUrl),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          introLine,
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(CustomColor.white),
                          side: MaterialStateProperty.all(
                              BorderSide(color: CustomColor.grey3, width: 1.0)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        child: Text(
                          '거절',
                          style:
                              TextStyle(color: CustomColor.grey3, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(CustomColor.primary1),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        onPressed: () async {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/icons/email.png',
                                color: CustomColor.grey5),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '참여',
                              style: TextStyle(
                                  color: CustomColor.grey5,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    ]),
  );
}

Widget joinMsgBox(
    String name, String thumbnailUrl, String title, String introLine) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(children: [
      Row(children: [
        Image.asset('assets/icons/handshake.png'),
        Text(
          ' $name님이 테스트를 신청했어요',
          style: TextStyle(
              color: CustomColor.grey5,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        )
      ]),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  appIcon(thumbnailUrl),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          introLine,
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(CustomColor.primary1),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        onPressed: () async {},
                        child: Text(
                          '글 보러가기',
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    ]),
  );
}

Widget startMsgBox(
    String name, String thumbnailUrl, String title, String introLine) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(children: [
      Row(children: [
        Image.asset('assets/icons/handshake.png'),
        Text(
          ' $name',
          style: TextStyle(
              color: CustomColor.grey5,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        )
      ]),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  appIcon(thumbnailUrl),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          introLine,
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(CustomColor.primary1),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    onPressed: () async {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.link_outlined,
                          color: CustomColor.grey5,
                          size: 25,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '앱 링크로 참여하기',
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(CustomColor.primary1),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  onPressed: () async {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.link_outlined,
                        color: CustomColor.grey5,
                        size: 25,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '웹 링크로 참여하기',
                        style: TextStyle(
                            color: CustomColor.grey5,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    ]),
  );
}

Widget endMsgBox(
    String name, String thumbnailUrl, String title, String introLine) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(children: [
      Row(children: [
        Image.asset('assets/icons/handshake.png'),
        Text(
          ' $name',
          style: TextStyle(
              color: CustomColor.grey5,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        )
      ]),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  appIcon(thumbnailUrl),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          introLine,
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(CustomColor.primary1),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        onPressed: () async {},
                        child: Text(
                          '포인트 확인하러 가기',
                          style: TextStyle(
                              color: CustomColor.grey5,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              )            ],
          ),
        ),
      )
    ]),
  );
}

Widget appIcon(String thumbnailUrl) {
  return SizedBox(
    height: 60,
    width: 60,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: CachedNetworkImage(
        fit: BoxFit.fill,
        imageUrl: thumbnailUrl,
      ),
    ),
  );
}
