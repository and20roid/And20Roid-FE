import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../utility/common.dart';

class ListDetail extends StatefulWidget {
  final int intValue;
  final String title;
  final String nickname;
  final String createdDate;

  const ListDetail(
      {Key? key,
      required this.intValue,
      required this.title,
      required this.nickname,
      required this.createdDate,
      })
      : super(key: key);

  @override
  State<ListDetail> createState() => _ListDetailState();
}

class _ListDetailState extends State<ListDetail> {
  String content = '';
  List<dynamic> urls = [];
  int participantNum = 0;

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

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await requestRecruitingDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
        actions: [
          Text(widget.nickname),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: urls.map((url) {
              return CachedNetworkImage(imageUrl: url);
            }).toList(),
            options: CarouselOptions(
              height: 200.0,
              enlargeCenterPage: true,
              aspectRatio: 1,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              viewportFraction: 0.8,
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(content),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("작성일 : ${widget.createdDate.substring(0, 10)}"),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("현재 $participantNum명이 참여했어요!"),
              ),
              Spacer(),
              ElevatedButton(onPressed: () {}, child: Text("참가하기")),
            ],
          )
        ],
      ),
    );
  }
}
