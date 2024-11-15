import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/color_manager.dart';

class AppThemes {
  const AppThemes._();

  static ThemeData light() => ThemeData(
        primaryColor: ColorsManager.primaryLight,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: ColorsManager.primaryLight,
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ColorsManager.primaryLight,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          elevation: 5,
          color: ColorsManager.card,
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
                const WidgetStatePropertyAll(ColorsManager.primaryLight),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
          ),
        ),
        tabBarTheme: TabBarTheme(
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: ColorsManager.secondaryLight,
          unselectedLabelColor: ColorsManager.disabled,
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

  static ThemeData dark() => ThemeData(
        primaryColor: ColorsManager.primaryLight,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.white,
          primary: ColorsManager.primaryLight,
          secondary: ColorsManager.secondaryLight,
          surface: ColorsManager.container,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorsManager.primaryLight,
          foregroundColor: Colors.white,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ColorsManager.primaryLight,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          // elevation: 5,
          color: ColorsManager.card,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(6),
          // ),
          // clipBehavior: Clip.antiAlias,
          // margin: const EdgeInsets.symmetric(
          //   horizontal: 4,
          //   vertical: 6,
          // ),
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
                const WidgetStatePropertyAll(ColorsManager.primaryLight),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
          ),
        ),
        tabBarTheme: TabBarTheme(
          // labelPadding: EdgeInsets.symmetric(horizontal: 8),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: ColorsManager.secondaryLight,
          unselectedLabelColor: ColorsManager.disabled,
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
