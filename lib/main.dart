import 'dart:convert';
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

  void init() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    await FirebaseMessaging.instance.requestPermission(
      badge: true,
      alert: true,
      sound: true,
    );
  }

  void firebaseMessageSetting() async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
    );

    var androidSetting =
        const AndroidInitializationSettings('@drawable/ic_notification');
    var initializationSettings =
        InitializationSettings(android: androidSetting);

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging messaging = FirebaseMessaging.instance;
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
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void firebaseMessageProc() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("message from 앱이 foreground에서 실행 중");
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("message from 앱이 백그라운드로 보내거나 앱이 완전히 종료된 상태 ");
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
      }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print("message from 앱이 완전히 종료된 상태");
      if (message != null) if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
      }
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future onSelectNotification(String id) async {
  print("onSelectNotification $id");
}

///실행중 알림 수신 또는 알림 클릭을 통해 진입
movePage(RemoteMessage message) async {
  AndroidNotification? android = message.notification?.android;
  String messageData = jsonEncode(message.data).toString();
  Map messageMap = jsonDecode(messageData);
  String? id = "";
  print('-----------movePage 실행');
  if (android != null) {
    if (message.notification?.android?.channelId != null) {
      id = message.notification?.android?.channelId;
    } else {
      id = messageMap['channelId'];
    }
  } else {
    id = messageMap['channel_id'];
  }
  onSelectNotification(id!);
}
