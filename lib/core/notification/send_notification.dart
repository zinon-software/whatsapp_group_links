import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:linkati/config/app_config.dart';

Future<void> sendFCMMessage({
  required String title,
  required String body,
  required String token, // توكن الجهاز المستهدف
  required Map<String, dynamic> data,
}) async {
  final url =
      'https://fcm.googleapis.com/v1/projects/${AppConfig.instance.fcmSenderId}/messages:send';

  final accountCredentials =
      ServiceAccountCredentials.fromJson(AppConfig.instance.serviceAccountData);
  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  await clientViaServiceAccount(accountCredentials, scopes).then(
    (AuthClient client) async {
      final payload = {
        "message": {
          "token": token, // توكن الجهاز المستهدف
          "notification": {
            "title": title,
            "body": body,
          },
          "data": data, // بيانات مخصصة
          "android": {
            "notification": {
              "icon": "ic_notification", // اسم الأيقونة في drawable
              "color": "#ff0000",
              "sound": "default",
              "click_action": "TOP_STORY_ACTIVITY",
            }
          },
          "apns": {
            "payload": {
              "aps": {"category": "NEW_MESSAGE_CATEGORY"}
            }
          }
        }
      };

      final response = await client.post(
        Uri.parse(url),
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Message sent successfully');
        }
      } else {
        if (kDebugMode) {
          print('Failed to send message: ${response.body}');
        }
      }

      client.close();
    },
  );
}

Future<void> sendFCMMessageToAllUsers({
  required String title,
  required String body,
  required Map<String, dynamic> data,
  required String topic,
}) async {
  final url =
      'https://fcm.googleapis.com/v1/projects/${AppConfig.instance.fcmSenderId}/messages:send';

  final accountCredentials =
      ServiceAccountCredentials.fromJson(AppConfig.instance.serviceAccountData);
  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  await clientViaServiceAccount(accountCredentials, scopes).then(
    (AuthClient client) async {
      final payload = {
        "message": {
          "topic": topic, // الموضوع الذي يتم إرسال الإشعار له
          "notification": {
            "title": title,
            "body": body,
          },
          "data": data, // بيانات مخصصة
          "android": {
            "notification": {
              "icon": "ic_notification", // اسم الأيقونة في drawable
              "color": "#ff0000",
              "sound": "default",
              "click_action": "TOP_STORY_ACTIVITY",
            }
          },
          "apns": {
            "payload": {
              "aps": {
                "alert": {
                  "title": title,
                  "body": body,
                },
                "sound": "default",
                "category": "NEW_MESSAGE_CATEGORY",
              }
            }
          }
        }
      };

      final response = await client.post(
        Uri.parse(url),
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Message sent successfully to all users');
        }
      } else {
        if (kDebugMode) {
          print('Failed to send message: ${response.body}');
        }
      }

      client.close();
    },
  );
}
