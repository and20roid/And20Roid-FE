import 'dart:convert';
import 'package:and20roid/utility/common.dart';
import 'package:and20roid/view/alarm/notification_controller.dart';
import 'package:and20roid/view/alarm/notification_page.dart';
import 'package:and20roid/view/ranking/ranking_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'direct_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.getToken();
  await initialization(null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    init();
    firebaseMessageSetting();
    firebaseMessageProc(context);

    return GetMaterialApp(
      color: CustomColor.grey5,
      home: const DirectingPage(),
    );
  }
}

bool kIsWeb = false;

void init() async {
  // await deleteToken();

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  await FirebaseMessaging.instance.requestPermission(
    badge: true,
    alert: true,
    sound: true,
  );
  String? token = await FirebaseMessaging.instance.getToken();
  print("fcm token $token");
}

void firebaseMessageSetting() async {
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
  );

  var androidSetting =
      const AndroidInitializationSettings('@drawable/appstore');
  var initializationSettings = InitializationSettings(android: androidSetting);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.setAutoInitEnabled(true);
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

void firebaseMessageProc(context) {
  final notificationController = Get.put(NotiController());
  final rankCtrl = Get.put(RankingController());

  ///알림 수신[앱 실행중]
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("message from 앱이 foreground에서 실행 중");

    if (message.notification != null) {
      print(message.notification!.title);
      print(message.notification!.body);
    }

    String jsonString = jsonEncode({
      'data': message.data,
      'notification': {
        'title': message.notification?.title,
        'body': message.notification?.body,
      },
    });

    print("Message as JSON: $jsonString");

    if (!kIsWeb && message.data["clickAction"] != null) {
      String msgAction = message.data["clickAction"].toString();
      print("Action: ${message.data["clickAction"].toString()}");
      if (msgAction == 'requestTest') {
        notificationController.alarmCount.value++;

        print('requestTest');
      } else if (msgAction == 'joinTest') {
        notificationController.alarmCount.value++;
        print('joinTest');
      } else if (msgAction == 'startTest') {
        notificationController.alarmCount.value++;
        print('startTest');
      } else if (msgAction == 'endTest') {
        notificationController.alarmCount.value++;
        print('endTest');
      }
    }
  });

  ///알림 클릭[앱 실행중]
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print(message.notification!.title);
      print(message.notification!.body);

      Get.to(() => NotificationContent());
    }
  });

  ///알림 클릭[앱 종료 상태]
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    print("message from 앱이 완전히 종료된 상태");
    if (message != null && message.notification != null) {
      print(message.notification!.title);
      print(message.notification!.body);

      Future.delayed(const Duration(seconds: 5), () {
        Get.to(() => NotificationContent());
      });
    }
  });
}

///백그라운드 알림 수신
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> deleteToken() async {
  final url = Uri.parse('${Common.url}users/tokens');
  String? bearerToken = await FirebaseAuth.instance.currentUser!.getIdToken();
  try {
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken', // 토큰을 헤더에 포함
      },
    );

    if (response.statusCode == 200) {
      print('Token deletion successful');
    } else {
      print('Token deletion failed. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error during token deletion: $e');
  }
}

Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 2));
}
