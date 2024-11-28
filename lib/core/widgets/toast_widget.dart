import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/color_manager.dart';


showToast(String text,
    {bool long = false,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.black87}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    gravity: gravity,
    timeInSecForIosWeb: long ? 5 : 2,
    backgroundColor: backgroundColor,
    textColor: ColorsManager.fillColor,
    fontSize: 16.0.sp,
  );
}
