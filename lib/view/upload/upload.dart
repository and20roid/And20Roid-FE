import 'dart:convert';
import 'dart:io';
import 'package:and20roid/utility/common.dart';
import 'package:dio/dio.dart' show MultipartFile, FormData, Options, Dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart' as getx;
import 'package:http_parser/http_parser.dart';

class UploadGetx extends getx.GetxController {
  getx.Rx<File?> appIconImage = getx.Rx<File?>(null);
  List<File> appPhotoImage = [];

  Future<void> uploadImages(
    String title,
    String introLine,
    String recruitNum,
    List<File> appPhotoImage,
    File appIconImage,
    String appLink,
    String webLink,
    String content,
  ) async {
    final url = '${Common.url}boards';
    final Dio dio = Dio();

    try {
      List<MultipartFile> appPhotoFiles = appPhotoImage
          .map(
            (img) => MultipartFile.fromFileSync(
              img.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          )
          .toList();

      MultipartFile appIconFile = MultipartFile.fromFileSync(
        appIconImage.path,
        contentType: MediaType('image', 'jpeg'),
      );

      Map<String, dynamic> jsonData = {
        'title': title,
        'content': content,
        'recruitmentNum': int.parse(recruitNum),
        'introLine': introLine,
        'appTestLink': appLink,
        'webTestLink': webLink,
      };

      String jsonString = jsonEncode(jsonData);

      FormData formData = FormData.fromMap({
        'dto': MultipartFile.fromString(
          jsonString,
          contentType: MediaType.parse('application/json'),
        ),
        'thumbnail': appIconFile,
        'images': appPhotoFiles,
      });

      String? bearerToken =
          await FirebaseAuth.instance.currentUser!.getIdToken();
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
}
