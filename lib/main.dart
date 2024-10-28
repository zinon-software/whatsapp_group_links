import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:linkati/firebase_options.dart';


import 'src/screens/home_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  MobileAds.instance.initialize();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              details.exception.toString(),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black, fontSize: 14),
          bodyMedium: TextStyle(color: Colors.black, fontSize: 12),
          bodySmall: TextStyle(color: Colors.black, fontSize: 10),
          titleLarge: TextStyle(color: Colors.black, fontSize: 16),
          titleMedium: TextStyle(color: Colors.black, fontSize: 14),
          titleSmall: TextStyle(color: Colors.black, fontSize: 12),
        ),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.green, // لون العنصر الأساسي
          secondary: Colors.blue, // لون الخلفية
          surface: Colors.white, // لون السطح (مثل خلفية البطاقات)
          error: Colors.red, // لون الخطأ
          onPrimary: Colors.white, // لون النص على العنصر الأساسي
          onSecondary: Colors.white, // لون النص على الخلفية
          onSurface: Colors.black, // لون النص على السطح
          onError: Colors.white, // لون النص على الخطأ
          
        ),
        appBarTheme: const AppBarTheme(
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(
            // إضافة BorderRadius للتغيير في شكل الزوايا
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale("ar", "AE")],
      locale: const Locale("ar", "AE"),
      home: const HomeScreen(),
    );
  }
}

