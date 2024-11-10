import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../utils/color_manager.dart';
import 'custom_button_widget.dart';

class AppAlert {
  const AppAlert._();

  static void dismissDialog(BuildContext context) {
    if (_isThereCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  static bool _isThereCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  static Future<void> loading(BuildContext context) {
    FocusScope.of(context).unfocus();
    dismissDialog(context);

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false, // لمنع الرجوع باستخدام زر back
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.25,
              heightFactor: 0.1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: const CircularProgressIndicator(
                      // color: Theme.of(context).textTheme.displayLarge!.color!,
                      // size: 45.0.w,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> showAlert(
    BuildContext context, {
    Widget? child,
    IconData? icon,
    Color? btnCancelColor,
    String? subTitle,
    String? title,
    Color? iconColor,
    String? cancelText = "إغلاق",
    String? confirmText = "تأكيد",
    void Function()? onConfirm,
    void Function()? onCancel,
    bool dismissOn = true,
  }) async {
    dismissDialog(context);
    await AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      headerAnimationLoop: false,
      body: child ??
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                if (icon != null)
                  Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Icon(
                      size: 45,
                      icon,
                      color: iconColor,
                    ),
                  ),
                if (title != null) ...[
                  SizedBox(height: 5),
                  Text(
                    title,
                    style: TextStyle(
                      color: ColorManager.black,
                      fontSize: 15,
                    ),
                  ),
                ],
                SizedBox(height: 5),
                Text(
                  subTitle ?? "",
                  style: TextStyle(
                    color: ColorManager.black,
                    fontSize: 13,
                  ),
                ),
                subTitle == null
                    ? const SizedBox.shrink()
                    : SizedBox(height: 20),
                Row(
                  children: [
                    if (onConfirm != null)
                      Expanded(
                        child: CustomButtonWidget(
                          onPressed: onConfirm,
                          label: confirmText,
                        ),
                      ),
                    if (onConfirm != null) const SizedBox(width: 10),
                    Expanded(
                      child: CustomButtonWidget(
                        backgroundColor: ColorManager.fillColor,
                        onPressed: onCancel ?? () => dismissDialog(context),
                        label: cancelText,
                        textColor: Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
      isDense: true,
      padding: const EdgeInsets.all(8),
      dialogBorderRadius: BorderRadius.circular(15),
      dismissOnTouchOutside: dismissOn,
      dismissOnBackKeyPress: dismissOn,
    ).show();
  }
}
