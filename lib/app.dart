import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'src/routes/app_routes.dart';
import 'src/utils/color_manager.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppNavigation.navigatorKey,
      initialRoute: AppRoutes.homeRoute,
      onGenerateRoute: AppNavigation.generate,
      debugShowCheckedModeBanner: false,
      title: "Linkati",
      theme: themeData(),
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale("ar", "AE")],
      locale: const Locale("ar", "AE"),
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
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: ColorManager.secondaryLight,
      unselectedLabelColor: ColorManager.disabled,
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
