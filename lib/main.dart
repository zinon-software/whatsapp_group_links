import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:linkati/firebase_options.dart';

import 'src/screens/home_screen.dart';
import 'src/utils/color_manager.dart';

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
      theme: themeData(),
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

ThemeData themeData() {
  return ThemeData(
    primaryColor: ColorManager.primaryLight,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.white,
      primary: ColorManager.primaryLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorManager.primaryLight,
      foregroundColor: Colors.white,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: ColorManager.container,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ColorManager.primaryLight,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(
      elevation: 5,
      color: ColorManager.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 6,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: WidgetStateProperty.resolveWith<BorderSide>(
          (states) => const BorderSide(width: 1, color: Colors.green),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        )),
        backgroundColor:
            const WidgetStatePropertyAll(ColorManager.primaryLight),
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
      ),
    ),
    tabBarTheme: TabBarTheme(
      // labelPadding: EdgeInsets.symmetric(horizontal: 8),
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: ColorManager.secondaryLight,
      unselectedLabelColor: ColorManager.disabled,
      // dividerColor: Colors.transparent,
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
