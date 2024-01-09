import 'dart:convert';
import 'dart:io';
import 'package:and20roid/utility/common.dart';
import 'package:dio/dio.dart' show MultipartFile, FormData, Options, Dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart' as getx;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../bottom_navigator.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  List<File>? _imageFiles = [];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _appTestLinkController = TextEditingController();
  TextEditingController _webTestLinkController = TextEditingController();
  TextEditingController _recruitController = TextEditingController();

  void _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFiles!.add(File(pickedFile.path));
      });
    }
  }

  Future<void> uploadImages(List<File> imageFiles,String title, String content, String appLink, String webLink, int _recruitNum) async {
    final url = '${Common.url}boards';
    final Dio dio = Dio();
    final List<MultipartFile> _files = imageFiles
        .map(
          (img) => MultipartFile.fromFileSync(
            img.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        )
        .toList();
    try {
      Map<String, dynamic> jsonData = {
        'title': title,
        'content': content,
        'recruitmentNum': _recruitNum,
        'appTestLink': appLink,
        'webTestLink': webLink
      };

      String jsonString = jsonEncode(jsonData);

      FormData formData = FormData.fromMap({
        'dto': MultipartFile.fromString(
          jsonString,
          contentType: MediaType.parse('application/json'),
        ),
        'thumbnail': _files[0],
        'images':_files[1],
      });

      String? bearerToken = await FirebaseAuth.instance.currentUser!.getIdToken();
      print("~~~~~~~clicked");

      var response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      print("~~~~~~done");

      if (response.statusCode == 200) {
        print('파일 업로드 성공!');
      } else {
        print('파일 업로드 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('등록하기', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () async{
              if (_contentController.text.isNotEmpty) {
                await uploadImages(_imageFiles!, _titleController.text, _contentController.text, _appTestLinkController.text, _webTestLinkController.text, int.parse(_recruitController.text));
                getx.Get.offAll(() => BottomNavigatorPage());
              } else {
                print('이미지와 내용을 모두 입력해주세요.');
              }
            },
            child: Text("업로드", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imageFiles!.length + 1,
                // +1 for the "add" button
                itemBuilder: (context, index) {
                  if (index < _imageFiles!.length) {
                    // Display the selected images
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Stack(
                        children: [
                          Image.file(
                            _imageFiles![index],
                            fit: BoxFit.cover,
                            height: 120,
                            width: 80,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _imageFiles!.removeAt(index);
                                });
                              },
                              icon: Icon(Icons.close, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Display the "add" button to pick more images
                    return InkWell(
                      onTap: _pickImageFromGallery,
                      child: Container(
                        height: 120,
                        width: 80, // Set width to the screen width
                        color: Colors.grey,
                        child: Icon(Icons.add, color: Colors.white, size: 40),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: "제목 입력",
            ),
            maxLines: 3,
          ),
          TextFormField(
            controller: _contentController,
            decoration: const InputDecoration(
              hintText: "내용 입력",
            ),
            maxLines: 3,
          ),
          TextFormField(
            controller: _recruitController,
            decoration: const InputDecoration(
              hintText: "모집 인원",
            ),
            maxLines: 3,
          ),
          TextFormField(
            controller: _appTestLinkController,
            decoration: const InputDecoration(
              hintText: "앱 링크 입력",
            ),
            maxLines: 3,
          ),
          TextFormField(
            controller: _webTestLinkController,
            decoration: const InputDecoration(
              hintText: "웹 링크 입력",
            ),
            maxLines: 3,
          ),
        ]),
      ),
    );
  }
}
