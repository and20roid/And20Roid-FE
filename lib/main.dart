import 'dart:convert';
import 'package:and20roid/view/alarm/notification_controller.dart';
import 'package:and20roid/view/alarm/notification_page.dart';
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    init();
    firebaseMessageSetting();
    firebaseMessageProc();

    return const GetMaterialApp(
      home: DirectingPage(),
    );
  }
}
bool kIsWeb = false;

void init() async {

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
      const AndroidInitializationSettings('@drawable/ic_notification');
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

void firebaseMessageProc() {
  final notificationController = Get.put(NotiController());

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

    notificationController.alarmCount.value++;
    print(notificationController.alarmCount.value);

    if (!kIsWeb && message.data["action"] != null) {
      String msgAction = message.data["action"].toString();
      print("Action: ${message.data["action"].toString()}");
      if (msgAction == 'requestTest') {
        notificationController.alarmCount.value++;
      } else if (msgAction == 'joinTest') {
        notificationController.alarmCount.value++;

      } else if (msgAction == 'startTest') {
        notificationController.alarmCount.value++;

      } else if (msgAction == 'endTest') {
        notificationController.alarmCount.value++;

      }
    }
  });

  ///알림 클릭[앱 실행중]
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print(message.notification!.title);
      print(message.notification!.body);
    }
  });

  ///알림 클릭[앱 종료 상태]
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    print("message from 앱이 완전히 종료된 상태");
    if (message != null && message.notification != null) {
      print(message.notification!.title);
      print(message.notification!.body);

      Future.delayed(const Duration(seconds: 5), () {
        movePage(message);
      });
    }
  });
}

///백그라운드 알림 수신
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

///실행중 알림 수신 또는 알림 클릭을 통해 진입
movePage(RemoteMessage message) async {
  print('-----------movePage 실행 mesage : $message');

  // String clickAction = message.data['clickAction'];
  // print('clickAction: $clickAction');
  // Get.to(()=>NotificationContent());

  // if(clickAction == "testRequest"){
  //     Get.to(()=>NotificationContent());
  // }
}
