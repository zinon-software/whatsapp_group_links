import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:linkati/firebase_options.dart';


import 'new_code/screens/home_screen.dart';

// SharedPreferences? prefs;
// String? urlServer, bannarIsAd, interstIsAd, nativeIsAd;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // prefs = await SharedPreferences.getInstance();
  // print(prefs?.getString('token'));
  // print(prefs?.getInt('user_id'));

  // GlobalBindings().dependencies();

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

    // const GetMaterialApp(
    //   debugShowCheckedModeBanner: false,
    // themeMode: ThemeMode.dark,
    // localizationsDelegates: [
    //   GlobalCupertinoLocalizations.delegate,
    //   GlobalMaterialLocalizations.delegate,
    //   GlobalWidgetsLocalizations.delegate,
    // ],
    // supportedLocales: [Locale("ar", "AE")],
    // locale: Locale("ar", "AE"),
    // home: SplashView(),
    // );
  }
}

// class GlobalBindings extends Bindings {
//   @override
//   void dependencies() {
//     // ignore: unused_local_variable
//     Get.put(PostController(), permanent: true);
//     // ignore: unused_local_variable
//     Get.put(UsersController());
//     // ignore: unused_local_variable
//     Get.lazyPut(() => FromPostController(), fenix: true);
//     // ignore: unused_local_variable
//     Get.lazyPut(() => NotificationController(), fenix: true);
//     // ignore: unused_local_variable
//     Get.lazyPut(() => LikeController(), fenix: true);
//   }
// }
