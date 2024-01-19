import 'dart:io';

import 'package:and20roid/view/upload/upload.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Get 패키지를 import
import 'package:image_picker/image_picker.dart';

import '../../bottom_navigator.dart';
import '../../utility/common.dart';

class UploadFirstController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController oneLineController = TextEditingController();
  TextEditingController recruitNumController = TextEditingController();
}

class UploadThirdController extends GetxController {
  TextEditingController appLinkController = TextEditingController();
  TextEditingController webLinkController = TextEditingController();
  TextEditingController contentController = TextEditingController();
}

class UploadFirst extends StatelessWidget {
  const UploadFirst({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.grey1,
      appBar: _appbar("프로젝트 업로드", false),
      body: SingleChildScrollView(
        child: GetBuilder<UploadFirstController>(
          init: UploadFirstController(), // GetBuilder로 컨트롤러 초기화
          builder: (controller) {
            return _body(controller);
          },
        ),
      ),
    );
  }
}

class UploadSecond extends StatefulWidget {
  const UploadSecond({super.key});

  @override
  State<UploadSecond> createState() => _UploadSecondState();
}

class _UploadSecondState extends State<UploadSecond> {
  final UploadGetx total = Get.put(UploadGetx());

  void pickappIconFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      total.appIconImage.value = File(pickedFile.path);
    }
    setState(() {});
  }

  void pickPhotoFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      total.appPhotoImage.add((File(pickedFile.path)));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: CustomColor.grey1,
      appBar: _appbar("앱 사진 등록", true),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              ' 앱 아이콘',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: InkWell(
                onTap: () {
                  pickappIconFromGallery();
                },
                child: appIcon(total.appIconImage.value),
              ),
            ),
            const Padding(
              padding:  EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                ' 앱 사진',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3, // 최대 3장까지만 허용
                itemBuilder: (context, index) {
                  if (index < total.appPhotoImage.length) {
                    // Display the selected images
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Stack(
                        children: [
                          appPhoto(total.appPhotoImage[index]),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                total.appPhotoImage.removeAt(index);
                                setState(() {});
                              },
                              icon: Icon(Icons.close, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (index == total.appPhotoImage.length && index < 3) {
                    return InkWell(
                      onTap: () {
                        pickPhotoFromGallery();
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 220,
                            width: 100,
                            decoration: BoxDecoration(
                              color: CustomColor.white,
                              border: Border.all(color: CustomColor.grey4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          Positioned(
                            top: 95,
                            left: 38,
                            child: Icon(
                              Icons.add,
                              color: CustomColor.grey4,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Placeholder for unused slots (if itemCount is 3)
                    return Container();
                  }
                },
              ),
            ),


            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => UploadThird());
                    },
                    child: Text(
                      "다음",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(CustomColor.primary1),
                      minimumSize: MaterialStateProperty.all(Size(100, 60)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      )),
    );
  }
}

class UploadThird extends StatelessWidget {
  const UploadThird({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.grey1,
      appBar: _appbar("서비스 소개", true),
      body: GetBuilder<UploadThirdController>(
        init: UploadThirdController(), // GetBuilder로 컨트롤러 초기화
        builder: (controller) {
          return _body3(controller);
        },
      ),
    );
  }
}

AppBar _appbar(title, isback) {
  return AppBar(
    elevation: 0.2,
    backgroundColor: CustomColor.grey1,
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    automaticallyImplyLeading: isback,
  );
}

Column _body(UploadFirstController controller) {
  return Column(
    children: [
      CustomInputField("서비스 명", controller.titleController, "서비스의 이름을 입력해주세요"),
      CustomInputField(
          "한 줄 소개", controller.oneLineController, "20자 이내로 입력해주세요"),
      CustomInputField("모집인원", controller.recruitNumController, "20"),
      Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => UploadSecond());
              },
              child: Text(
                "다음",
                style: TextStyle(fontSize: 18),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(CustomColor.primary1),
                minimumSize: MaterialStateProperty.all(Size(100, 60)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          )),
    ],
  );
}

Widget appIcon(File? appIconImage) {
  return (appIconImage == null)
      ? Stack(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: CustomColor.white,
                border: Border.all(color: CustomColor.grey4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Positioned(
                top: 38,
                left: 38,
                child: Icon(
                  Icons.add,
                  color: CustomColor.grey4,
                )),
          ],
        )
      : Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: CustomColor.white,
            border: Border.all(color: CustomColor.grey4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(appIconImage, fit: BoxFit.cover),
          ),
        );
}

Widget appPhoto(File appPhotoImage) {
  return Container(
    height: 220,
    width: 100,
    decoration: BoxDecoration(
      color: CustomColor.white,
      border: Border.all(color: CustomColor.grey4),
      borderRadius: BorderRadius.circular(12),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(appPhotoImage, fit: BoxFit.cover),
    ),
  );
}

Column _body3(UploadThirdController controller) {
  final UploadGetx total = Get.put(UploadGetx());
  final UploadFirstController first = Get.put(UploadFirstController());
  final UploadThirdController third = Get.put(UploadThirdController());


  return Column(
    children: [
      CustomInputField("앱 링크", controller.appLinkController, "스토어 url을 입력해주세요"),
      CustomInputField("앱 링크", controller.webLinkController, "웹 url을 입력해주세요"),
      CustomInputField(
          "서비스 소개", controller.contentController, "서비스를 자유롭게 소개해주세요"),
      Spacer(),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: () {
            File? appIconImageValue = total.appIconImage.value;
            if (appIconImageValue != null) {
              // appIconImageValue 사용 가능
              total.uploadImages(
                first.titleController.text,
                first.oneLineController.text,
                first.recruitNumController.text,
                total.appPhotoImage,
                appIconImageValue,
                third.appLinkController.text,
                third.webLinkController.text,
                third.contentController.text,
              );
            } else {
              print("앱 아이콘이 없음");
            }

            Get.offAll(() => const BottomNavigatorPage());
          },
          child: Text(
            "업로드 하기",
            style: TextStyle(fontSize: 18),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(CustomColor.primary1),
            minimumSize: MaterialStateProperty.all(Size.fromHeight(60)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget CustomInputField(title, TextEditingController testController, hintText) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: testController,
          style: TextStyle(fontSize: 16, color: CustomColor.grey3),
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: CustomColor.grey3, width: 1),
            ),
          ),
          maxLines: 1,
        ),
      ],
    ),
  );
}
