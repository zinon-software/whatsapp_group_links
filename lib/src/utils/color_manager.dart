import 'package:flutter/material.dart';

class ColorManager {
  const ColorManager._();

  // الألوان لوضع النهار (السمة الفاتحة)
  // static const Color primaryLight = Color(0xff354276);
  static const Color primaryLight = Colors.green;
  static const Color secondaryLight = Color(0xFFE56510);
  // ... باقي الألوان لوضع النهار

  // الألوان لوضع الليل (السمة المظلمة)
  static const Color primaryDark = Color(0xFF00796B);
  static const Color secondaryDark = Color(0xFFE64A19);

  // خلفية وأمامية لوضع النهار
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color foregroundLight = Color(0xFF333333);

  // خلفية وأمامية لوضع الليل
  static const Color backgroundDark = Color(0xFF111111);
  static const Color foregroundDark = Color(0xFFCCCCCC);

  // باقي الألوان المشتركة بين الوضعين
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF616161);
  static const Color iconPrimary = Color(0xFF9E9E9E);
  static const Color iconSecondary = Color(0xFFBDBDBD);
  static const Color container = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFE8EAF0);
  static const Color accent = Color(0xFF4CAF50);
  static const Color error = Color(0xFFB00020);
  static const Color cancel = Color(0xFF757575);

  // Adjusted opacities for better contrast and readability
  static Color hidden = const Color(0xFFFAFAFA).withOpacity(0.9);
  static Color disabled = const Color(0xFFFECEAB).withOpacity(0.9);
}
