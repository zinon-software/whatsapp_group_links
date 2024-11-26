import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static AppConfig? _instance;
  static AppConfig get instance => _instance ??= AppConfig._init();
  AppConfig._init();

  final Map<String, dynamic> serviceAccountData = {
    "type": "service_account",
    "project_id": dotenv.env['FIREBASE_PROJECT_ID']!,
    "private_key_id": dotenv.env['FIREBASE_PRIVATE_KEY_ID']!,
    "private_key": dotenv.env['FIREBASE_PRIVATE_KEY']!,
    "client_email": dotenv.env['FIREBASE_CLIENT_EMAIL']!,
    "client_id": dotenv.env['FIREBASE_CLIENT_ID']!,
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": dotenv.env['FIREBASE_CLIENT_X509_CERT_URL']!,
    "universe_domain": "googleapis.com"
  };
  final String fcmSenderId = dotenv.env['FIREBASE_FCM_SENDER_ID']!;

  factory AppConfig() {
    return instance;
  }
}
