import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../model/list_model.dart';
import '../../utility/common.dart';
import 'adState.dart';
import 'list_controller.dart';
import 'list_detail.dart';

class ListContent extends StatefulWidget {
  @override
  State<ListContent> createState() => _ListContentState();
}

class _ListContentState extends State<ListContent> {
  final listCtrl = Get.find<ListController>();

  // BannerAd? banner;
  // bool _bannerIsLoaded = false;

  @override
  void initState() {
    super.initState();
    // final adState = Provider.of<AdState>(context, listen: false);
    // adState.initialisation.then((status) {
    //   setState(() {
    //     banner = BannerAd(
    //       adUnitId: adState.bannerAdUnitId,
    //       size: AdSize.banner,
    //       request: const AdRequest(),
    //       listener: adState.adListener,
    //     )..load();
    //
    //     _bannerIsLoaded = true;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.grey1,
      appBar: _appBar(),
      body: GetBuilder<ListController>(
        builder: (listCtrl) {
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: listCtrl.refreshController,
            onRefresh: listCtrl.requestRecruitingList,
            scrollController: listCtrl.scrollController,
            onLoading: listCtrl.requestDownRecruitingList,
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Container();
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("다시 로드해주세요");
                } else {
                  body =Container();
                }
                return Container(
                  height: 20.0,
                  child: Center(child: body),
                );
              },
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listCtrl.gatherListItems.length,
              itemBuilder: (context, index) {
                if (index > 0 && (index + 1) % 5 == 0) {
                  return Column(
                    children: [
                      // _bannerIsLoaded
                      //     ? Container(
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(12.0),
                      //           border:
                      //               Border.all(color: Colors.black, width: 1.0),
                      //         ),
                      //         child: FutureBuilder(
                      //           // Use FutureBuilder to get the ad sizeㄴ
                      //           future: banner!.load(),
                      //           builder: (context, snapshot) {
                      //             if (snapshot.connectionState ==
                      //                 ConnectionState.done) {
                      //               double adHeight =
                      //                   banner!.size.height.toDouble();
                      //               return SizedBox(
                      //                 height: adHeight,
                      //                 child: AdWidget(ad: banner!),
                      //               );
                      //             } else {
                      //               // Return a placeholder or loading indicator if needed
                      //               return CircularProgressIndicator();
                      //             }
                      //           },
                      //         ))
                      //     : Container(),
                      InkWell(
                        onTap: () {
                          Get.to(
                            () => ListDetail(
                              intValue: listCtrl.gatherListItems[index].id,
                              title: listCtrl.gatherListItems[index].title,
                              nickname:
                                  listCtrl.gatherListItems[index].nickname,
                              createdDate:
                                  listCtrl.gatherListItems[index].createdDate,
                              thumbnailUrl:
                                  listCtrl.gatherListItems[index].thumbnailUrl,
                              likes: listCtrl.gatherListItems[index].likes,
                              views: listCtrl.gatherListItems[index].views,
                              urls: listCtrl.gatherListItems[index].imageUrls,
                              introLine:
                                  listCtrl.gatherListItems[index].introLine,
                              likedBoard:
                                  listCtrl.gatherListItems[index].likedBoard,
                              state : listCtrl.gatherListItems[index].state,
                              mine : listCtrl.gatherListItems[index].mine
                            ),
                            transition: Transition.leftToRight,
                          );
                        },
                        child: renderCard(
                          listCtrl.gatherListItems[index].participantNum
                              .toString(),
                          listCtrl.gatherListItems[index].title,
                          listCtrl.gatherListItems[index].introLine,
                          listCtrl.gatherListItems[index].imageUrls,
                          listCtrl.gatherListItems[index].thumbnailUrl,
                          listCtrl.gatherListItems[index].nickname,
                          listCtrl.gatherListItems[index].likes,
                          listCtrl.gatherListItems[index].views,
                          MediaQuery.of(context).size.width,
                          listCtrl.gatherListItems[index].likedBoard,
                        ),
                      )
                    ],
                  );
                } else {
                  return InkWell(
                    onTap: () {
                      Get.to(
                        () => ListDetail(
                          intValue: listCtrl.gatherListItems[index].id,
                          title: listCtrl.gatherListItems[index].title,
                          nickname: listCtrl.gatherListItems[index].nickname,
                          createdDate:
                              listCtrl.gatherListItems[index].createdDate,
                          thumbnailUrl:
                              listCtrl.gatherListItems[index].thumbnailUrl,
                          likes: listCtrl.gatherListItems[index].likes,
                          views: listCtrl.gatherListItems[index].views,
                          urls: listCtrl.gatherListItems[index].imageUrls,
                          introLine: listCtrl.gatherListItems[index].introLine,
                          likedBoard:
                              listCtrl.gatherListItems[index].likedBoard,
                          state: listCtrl.gatherListItems[index].state,
                          mine: listCtrl.gatherListItems[index].mine,
                        ),
                        transition: Transition.leftToRight,
                      );
                    },
                    child: renderCard(
                      listCtrl.gatherListItems[index].participantNum.toString(),
                      listCtrl.gatherListItems[index].title,
                      listCtrl.gatherListItems[index].introLine,
                      listCtrl.gatherListItems[index].imageUrls,
                      listCtrl.gatherListItems[index].thumbnailUrl,
                      listCtrl.gatherListItems[index].nickname,
                      listCtrl.gatherListItems[index].likes,
                      listCtrl.gatherListItems[index].views,
                      MediaQuery.of(context).size.width,
                      listCtrl.gatherListItems[index].likedBoard,
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
        foregroundColor: CustomColor.grey1,
        toolbarHeight: 80.0,
        backgroundColor: CustomColor.grey1,
        elevation: 1,
        title: SizedBox(
            width: 60,
            height: 60,
            child: Image.asset('assets/images/logoNoback.png')));
  }

  Card renderCard(
      String participantNum,
      String title,
      String intro,
      List<String> imageUrls,
      String thumbnailUrl,
      String nickname,
      int likes,
      int views,
      double screenWidth,
      bool liked) {
    return Card(
      elevation: 1,
      color: CustomColor.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.topLeft,
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
            child: Row(
              children: [
                appIcon(thumbnailUrl),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 255,
                        child: Text(
                          title,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      SizedBox(
                        width: 255,
                        child: Text(
                          intro,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          imageList(imageUrls, screenWidth),
          threeTitle(nickname, likes.toString(), views.toString(), liked),
        ],
      ),
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

  Widget imageList(List<String> urls, double screenWidth) {
    return SizedBox(
      height: screenWidth / 1.6,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 6.0, 0),
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

  Widget threeTitle(String nickname, String heart, String views, bool liked) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Text(nickname),
          const SizedBox(width: 16),
          liked
              ? const Icon(Icons.favorite, color: Colors.red)
              : const Icon(Icons.favorite_border_outlined,
                  color: Colors.red), // Heart icon
          Text(" $heart"),
          const SizedBox(width: 16),
          const Icon(Icons.visibility_outlined), // View count icon
          Text(' $views')
        ],
      ),
    );
  }
}
