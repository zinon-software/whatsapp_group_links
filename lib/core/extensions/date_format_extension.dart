import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatTimeAgoString() {
    Duration difference = DateTime.now().difference(this);

    if (difference < const Duration(seconds: 10)) {
      return "منذ ${difference.inSeconds} ثواني";
    } else if (difference < const Duration(minutes: 1)) {
      return "منذ ${difference.inSeconds} ثانية";
    } else if (difference < const Duration(hours: 1)) {
      return "منذ ${difference.inMinutes} دقيقة";
    } else if (difference < const Duration(days: 1)) {
      return "منذ ${difference.inHours} ساعة";
    } else if (difference < const Duration(days: 7)) {
      return "منذ ${difference.inDays} يوم";
    } else if (difference < const Duration(days: 30)) {
      int weeks = (difference.inDays / 7).floor();
      return "منذ $weeks أسبوع";
    } else if (difference < const Duration(days: 365)) {
      int months = (difference.inDays / 30).floor();
      return "منذ $months شهر";
    } else if (difference < const Duration(days: 365 * 2)) {
      return "منذ سنة";
    } else if (difference < const Duration(days: 365 * 3)) {
      return "منذ سنتين";
    } else {
      int years = (difference.inDays / 365).floor();
      return "منذ $years سنة";
    }
  }

  String timeAgo() {
    Duration difference = DateTime.now().difference(this);

    String formatNumber(int number) {
      return NumberFormat.decimalPattern('ar')
          .format(number); // تنسيق الأرقام بالعربية
    }

    if (difference < const Duration(seconds: 10)) {
      return "الآن";
    } else if (difference < const Duration(minutes: 1)) {
      return "${formatNumber(difference.inSeconds)} ث";
    } else if (difference < const Duration(hours: 1)) {
      return "${formatNumber(difference.inMinutes)} د";
    } else if (difference < const Duration(days: 1)) {
      return "${formatNumber(difference.inHours)} س";
    } else if (difference < const Duration(days: 7)) {
      return "${formatNumber(difference.inDays)} ي";
    } else if (difference < const Duration(days: 30)) {
      int weeks = (difference.inDays / 7).floor();
      return "${formatNumber(weeks)} أ";
    } else if (difference < const Duration(days: 365)) {
      int months = (difference.inDays / 30).floor();
      return "${formatNumber(months)} ش";
    } else {
      int years = (difference.inDays / 365).floor();
      return "${formatNumber(years)} س";
    }
  }
}
