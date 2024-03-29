import 'dart:convert';
import 'package:and20roid/utility/common.dart';
import 'package:and20roid/controller/notification_controller.dart';
import 'package:and20roid/view/alarm/notification_page.dart';
import 'package:and20roid/view/list/adState.dart';
import 'package:and20roid/controller/list_controller.dart';
import 'package:and20roid/view/list/list_page.dart';
import 'package:and20roid/view/mypage/my_page.dart';
import 'package:and20roid/controller/my_page_controller.dart';
import 'package:and20roid/controller/ranking_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'bottom_navigator.dart';
import 'direct_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance.getToken();
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    /// Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    /// Analytics
    FirebaseAnalytics.instance;
  } catch (e) {
    print('Error during Firebase initialization: $e');
  }
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);

  runApp(MultiProvider(providers: [
    Provider<AdState>(create: (_) => adState),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    init();
    firebaseMessageSetting();
    firebaseMessageProc(context);
    FlutterNativeSplash.remove();

    return GetMaterialApp(
      color: CustomColor.grey5,
      home: const DirectingPage(),
    );
  }
}

bool kIsWeb = false;

void init() async {
  Get.put(ListController());
  Get.put(NotiController());
  Get.put(RankingController());
  Get.put(MyPageControllrer());

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  await FirebaseMessaging.instance.requestPermission(
    badge: true,
    alert: true,
    sound: true,
  );

  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    print("FCM token: $token");
  } else {
    print("Warning: FCM token is null.");
  }
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
      notificationController.alarmCount.value++;
      notificationController.requestUserTestNum();
    }
  });

  ///알림 클릭[앱 실행중]
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      notificationController.alarmCount.value++;
    }
  });

  ///알림 클릭[앱 종료 상태]
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    print("message from 앱이 완전히 종료된 상태");
    if (message != null && message.notification != null) {
      Future.delayed(const Duration(seconds: 3), () {
        Get.to(() => DirectingPage());
        notificationController.alarmCount.value++;
      });
    }
  });

  Future.delayed(const Duration(seconds: 1));
}

///백그라운드 알림 수신
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
