import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:linkati/features/links/data/models/link_model.dart';

import '../../config/app_injector.dart';
import '../routes/app_routes.dart';
import '../storage/storage_repository.dart';

class NotificationManager {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static late AndroidNotificationChannel _channel;

  static const AndroidInitializationSettings _initializationSettingsAndroid =
      AndroidInitializationSettings('ic_notification');

  static const DarwinInitializationSettings _initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  @pragma('vm:entry-point')
  static void initialize() async {
    _channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
    );

    // إنشاء قناة الإشعارات المحلية
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await _requestPermissions();

    // إعدادات البدء الكاملة
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: _initializationSettingsAndroid,
      iOS: _initializationSettingsDarwin,
    );

    // تهيئة مكتبة الإشعارات المحلية
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );

    // تهيئة استقبال الرسائل من Firebase Cloud Messaging (FCM)
    // تهيئة استقبال الرسائل من خدمة FCM في حالة عمل التطبيق في الخلفية
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // استقبال الرسائل من خدمة FCM في حالة عمل التطبيق في الواجهة الأمامية
    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
    // استقبال الرسائل عند فتح التطبيق من إشعار
    FirebaseMessaging.onMessageOpenedApp.listen(
      _firebaseMessagingOpenedAppHandler,
    );

    await subscribeToTopic("allUsers");
  }

  static Future<void> subscribeToTopic(String topic) async {
    instance<StorageRepository>().setData(key: topic, value: true);
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  static Future<void> unSubscribeToTopic(String topic) async {
    instance<StorageRepository>().setData(key: topic, value: false);
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  static Future<String> getNotificationToken() async {
    return await FirebaseMessaging.instance.getToken() ?? '';
  }

  static Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      icon: 'ic_notification',
      importance: Importance.max,
      priority: Priority.high,
      groupKey: 'notification_group',
      ticker: 'ticker',
    );

    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails(
      categoryIdentifier: 'plainCategory',
      presentSound: true,
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification?.title,
      notification?.body,
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    try {
      await Firebase.initializeApp();
      await showNotification(message);
    } catch (e) {
      //
    }
  }

  static Future<void> _firebaseMessagingForegroundHandler(
      RemoteMessage message) async {
    await showNotification(message);
  }

  static Future<void> _firebaseMessagingOpenedAppHandler(
      RemoteMessage message) async {
    navigatorRoutes(jsonEncode(message.data));
  }

  static void _onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      navigatorRoutes(payload);
    }
  }

  @pragma('vm:entry-point')
  static void _notificationTapBackground(
      NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    navigatorRoutes(payload);
  }

  static Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            provisional: true,
            critical: true,
          );
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            provisional: true,
            critical: true,
          );
    } else if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  static void navigatorRoutes(String? payload) {
    if (payload != null) {
      final data = jsonDecode(payload);
      final String route = data['route'] as String;
      if (route == AppRoutes.linkDetailsRoute) {
        AppNavigation.navigatorKey.currentState?.pushNamed(
          AppRoutes.linkDetailsRoute,
          arguments: {
            "link": LinkModel.fromStringData(
              jsonDecode(data['link']) as Map<String, dynamic>,
            ),
          },
        );
      } else if (route == AppRoutes.qnaDetailsRoute) {
        AppNavigation.navigatorKey.currentState?.pushNamed(
          AppRoutes.qnaDetailsRoute,
          arguments: {
            'question_id': data['question_id'],
          },
        );
      } else {
        AppNavigation.navigatorKey.currentState?.pushNamed(
          AppRoutes.homeRoute,
        );
      }
    } else {
      AppNavigation.navigatorKey.currentState?.pushNamed(
        AppRoutes.homeRoute,
      );
    }
  }
}
