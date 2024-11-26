import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:linkati/config/app_config.dart';

Future<void> sendFCMMessage(
  String title,
  String body,
  String token, // توكن الجهاز المستهدف
  Map<String, dynamic> data,
) async {
  final url =
      'https://fcm.googleapis.com/v1/projects/${AppConfig.instance.fcmSenderId}/messages:send';

  final accountCredentials =
      ServiceAccountCredentials.fromJson(serviceAccountKey);
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
//       "android": {
//         "notification": {"click_action": "TOP_STORY_ACTIVITY"}
//       },
//       "apns": {
//         "payload": {
//           "aps": {"category": "NEW_MESSAGE_CATEGORY"}
//         }
//       }
        }
      };

      final response = await client.post(
        Uri.parse(url),
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        print('Message sent successfully');
      } else {
        print('Failed to send message: ${response.body}');
      }

      client.close();
    },
  );
}
