import 'dart:io';

import 'package:and20roid/controller/upload_controller.dart';
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

class UploadView extends StatelessWidget {
  const UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.grey1,
      appBar: _appbar("프로젝트 업로드", false),
      body: SingleChildScrollView(
        child: GetBuilder<UploadFirstController>(
          init: UploadFirstController(), // GetBuilder로 컨트롤러 초기화
          builder: (controller) {
            return _body(controller, context);
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

  Future<void> pickPhotoFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      total.appPhotoImage.add((File(pickedFile.path)));
    }
    await total.calculateTotalSize(total.appPhotoImage);
    setState(() {});
  }

  Future<void> removePhoto(index) async {
    total.appPhotoImage.removeAt(index);
    await total.calculateTotalSize(total.appPhotoImage);
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                ' 앱 사진 ${total.totalFileSize.value >= 1000000 ? '${total.totalFileSize.value ~/ 1000000}MB' : '${total.totalFileSize.value ~/ 1000}KB'} / 15MB',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: total.totalFileSize.value ~/ (1000000) < 15
                        ? CustomColor.grey5
                        : Colors.red),
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
                              onPressed: () async {
                                await removePhoto(index);
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
                      onTap: () async {
                        await pickPhotoFromGallery();
                        setState(() {});
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
                      Get.to(() => UploadThird(),
                          transition: Transition.rightToLeftWithFade);
                    },
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
                    child: Text(
                      "다음",
                      style: TextStyle(fontSize: 18,color: CustomColor.grey5),
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
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: CustomColor.grey1,
      appBar: _appbar("서비스 소개", true),
      body: GetBuilder<UploadThirdController>(
        init: UploadThirdController(), // GetBuilder로 컨트롤러 초기화
        builder: (controller) {
          return SingleChildScrollView(
              child: SizedBox(
                  height: screenHeight - 80,
                  child: _body3(controller, context)));
        },
      ),
    );
  }
}

AppBar _appbar(title, isback) {
  return AppBar(
    elevation: 1,
    toolbarHeight: 80,
    backgroundColor: CustomColor.grey1,
    title: Text(
      title,
      style: const TextStyle(
          color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
    ),
    automaticallyImplyLeading: isback,
  );
}

Column _body(UploadFirstController controller, BuildContext context) {
  return Column(
    children: [
      CustomInputField("서비스 명", controller.titleController, "서비스의 이름을 입력해 주세요"),
      CustomInputField(
          "한 줄 소개", controller.oneLineController, "20자 이내로 입력해주세요"),
      CustomInputField("모집인원", controller.recruitNumController, "20"),
      Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                if (controller.titleController.text.isEmpty ||
                    controller.oneLineController.text.isEmpty ||
                    controller.recruitNumController.text.isEmpty) {
                  Common().showToastN(context, "모든 정보를 입력해 주세요", 1);
                } else {
                  if (controller.oneLineController.text.length > 20) {
                    Common().showToastN(context, "20자 이내로 작성해주세요", 1);
                  } else if (controller.recruitNumController.text.length > 2) {
                    Common().showToastN(context, "모집 인원은 100명 이내로 설정해주세요", 1);
                  } else {
                    Get.to(() => UploadSecond(),
                        transition: Transition.rightToLeftWithFade);
                  }
                }
              },
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
              child: Text(
                "다음",
                style: TextStyle(fontSize: 18,color: CustomColor.grey5),
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

Column _body3(UploadThirdController controller, context) {
  final UploadGetx total = Get.find<UploadGetx>();
  final UploadFirstController first = Get.put(UploadFirstController());
  final UploadThirdController third = Get.put(UploadThirdController());

  return Column(
    children: [
      CustomInputField("앱 링크", controller.appLinkController, "스토어 url을 입력해주세요"),
      CustomInputField("웹 링크", controller.webLinkController, "웹 url을 입력해주세요"),
      CustomInputField(
          "서비스 소개", controller.contentController, "서비스를 자유롭게 소개해주세요 (300자)"),
      Spacer(),
      Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 36.0),
        child: ElevatedButton(
          onPressed: () async {
            File? appIconImageValue = total.appIconImage.value;
            int totalSize = await total.calculateTotalSize(total.appPhotoImage);
            if (appIconImageValue != null) {
              if (totalSize < 15 * 1024 * 1024 && totalSize > 0) {
                if (controller.appLinkController.text.isEmpty ||
                    controller.webLinkController.text.isEmpty ||
                    controller.contentController.text.isEmpty) {
                  Common().showToastN(context, '내용을 모두 입력해주세요', 1);
                } else {
                  if (controller.contentController.text.length > 300) {
                    Common().showToastN(context, '내용을 300자 이내로 작성해주세요', 1);
                  } else {
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
                    Common().showToastN(context, '업로드 성공', 4);
                    first.titleController.dispose();
                    first.oneLineController.dispose();
                    first.recruitNumController.dispose();
                    third.appLinkController.dispose();
                    third.webLinkController.dispose();
                    third.contentController.dispose();
                    Get.offAll(() => const BottomNavigatorPage());
                  }
                }
              } else {
                Common().showToastN(context, '사진 크기를 확인해 주세요', 1);
                Get.back();
              }
            } else {
              Common().showToastN(context, '앱 아이콘을 확인해 주세요', 1);
              Get.back();
            }
          }
          // :null
          ,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(CustomColor.primary1),
            minimumSize: MaterialStateProperty.all(Size.fromHeight(60)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          child: Text(
            "업로드 하기",
            style: TextStyle(fontSize: 18,color: CustomColor.grey5),
          ),
        ),
      ),
    ],
  );
}

Widget CustomInputField(title, TextEditingController testController, hintText) {
  final UploadGetx total = Get.put(UploadGetx());

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
        (title == '모집인원')
            ? Row(
                children: [
                  Container(
                      width: 60,
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: testController,
                          style:
                              TextStyle(fontSize: 16, color: CustomColor.grey5),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(12),
                            hintText: hintText,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                  color: CustomColor.grey1, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // 포커스가 있을 때의 테두리 설정
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                  color: CustomColor.primary1, width: 1),
                            ),
                          ),
                          maxLines: 1)),
                  Text(
                    "  명",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              )
            : (title == '앱 링크' || title == '웹 링크')
                ? Form(
                    key: (title == '앱 링크')
                        ? total.uploadFormKey1
                        : total.uploadFormKey2,
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      controller: testController,
                      validator: validateURL,
                      style: TextStyle(fontSize: 16, color: CustomColor.grey5),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(12),
                        hintText: hintText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              BorderSide(color: CustomColor.grey1, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          // 포커스가 있을 때의 테두리 설정
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              BorderSide(color: CustomColor.primary1, width: 1),
                        ),
                      ),
                      maxLines: 1,
                    ),
                  )
                : TextFormField(
                    controller: testController,
                    style: TextStyle(fontSize: 16, color: CustomColor.grey5),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12),
                      hintText: hintText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            BorderSide(color: CustomColor.grey1, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // 포커스가 있을 때의 테두리 설정
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            BorderSide(color: CustomColor.primary1, width: 1),
                      ),
                    ),
                    maxLines: (title != '서비스 소개') ? 1 : 6,
                  ),
      ],
    ),
  );
}

String? validateURL(String? value) {
  if (value == null || value.isEmpty) {
    return 'https로 시작하는 URL을 입력해주세요.';
  }

  // URL 형식의 정규식
  final RegExp urlRegExp = RegExp(
    r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$',
    caseSensitive: false,
    multiLine: false,
  );

  if (!urlRegExp.hasMatch(value)) {
    return '올바른 URL 형식이 아닙니다.';
  }

  return null;
}
