import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppAlert {
  const AppAlert._();

  static void dismissDialog(BuildContext context) {
    if (_isThereCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  static bool _isThereCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  static Future<void> success(
    BuildContext context, {
    String body = 'تمت العملية بنجاح!',
    String confirmBtnText = "إغلاق",
    final void Function()? onConfirmBtnTap,
    bool dismissOn = true,
  }) async {
    dismissDialog(context);

    await AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      desc: body,
      btnOkText: confirmBtnText,
      btnOkOnPress: () {
        if (onConfirmBtnTap != null) {
          onConfirmBtnTap();
        }
      },
      isDense: true,
      dismissOnTouchOutside: dismissOn,
      dismissOnBackKeyPress: dismissOn,
    ).show();
  }

  static Future<void> error(
    BuildContext context, {
    String title = 'خطاء...',
    String body = 'Sorry, something went wrong',
    String confirmBtnText = 'اعد المحاولة',
    void Function()? onConfirmBtnTap,
    bool dismissOnBackKeyPress = true,
    bool dismissOnTouchOutside = true,
  }) async {
    dismissDialog(context);

    await AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      title: title,
      desc: body,
      btnOkText: confirmBtnText,
      btnOkOnPress: () {
        if (onConfirmBtnTap != null) {
          onConfirmBtnTap();
        }
      },
      isDense: true,
      dismissOnTouchOutside: dismissOnTouchOutside,
      dismissOnBackKeyPress: dismissOnBackKeyPress,
    ).show();
  }

  static Future<void> warning(
    BuildContext context, {
    String? title,
    String body = 'You just broke protocol',
    String confirmBtnText = "موافق",
    void Function()? onConfirmBtnTap,
    bool dismissOn = true,
  }) async {
    dismissDialog(context);

    await AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      title: title,
      desc: body,
      btnOkText: confirmBtnText,
      btnOkOnPress: () {
        if (onConfirmBtnTap != null) {
          onConfirmBtnTap();
        }
      },
      isDense: true,
      dismissOnTouchOutside: dismissOn,
      dismissOnBackKeyPress: dismissOn,
    ).show();
  }

  static Future<void> info(
    BuildContext context, {
    String body = 'Buy two, get one free',
    bool dismissOn = true,
  }) async {
    dismissDialog(context);

    await AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      desc: body,
      isDense: true,
      headerAnimationLoop: false,
      dismissOnTouchOutside: dismissOn,
      dismissOnBackKeyPress: dismissOn,
      btnOkText: "موافق",
      btnOkOnPress: () {},
    ).show();
  }

  static Future<void> confirm(
    BuildContext context, {
    String? title,
    String body = 'Do you want to logout',
    String okTixt = 'نعم',
    String cancelTixt = 'لأ',
    Color? btnCancelColor,
    void Function()? onConfirm,
    void Function()? onCancelBtnTap,
    bool dismissOn = false,
  }) async {
    dismissDialog(context);

    await AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      headerAnimationLoop: false,
      animType: AnimType.rightSlide,
      title: title,
      desc: body,
      btnOkText: okTixt,
      btnCancelText: cancelTixt,
      btnCancelColor: btnCancelColor,
      padding: const EdgeInsets.all(8),
      dialogBorderRadius: BorderRadius.circular(15),
      btnOkOnPress: () {
        if (onConfirm != null) {
          onConfirm();
        }
      },
      btnCancelOnPress: () {
        if (onCancelBtnTap != null) {
          onCancelBtnTap();
        }
      },
      dismissOnTouchOutside: dismissOn,
      dismissOnBackKeyPress: dismissOn,
      isDense: true,
    ).show();
  }

  static Future<void> loading(BuildContext context) {
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
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Center(
                  child:  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onSurface,
                    // size: 45.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> customAwesomeDialog(
    BuildContext context, {
    required Widget content,
    String okTixt = 'نعم',
    String cancelTixt = 'لأ',
    Color? btnCancelColor,
    String? title,
    void Function()? onConfirmBtnTap,
    void Function()? onCancelBtnTap,
    bool dismissOn = false,
  }) async {
    dismissDialog(context);

    await AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      headerAnimationLoop: false,
      title: title,
      body: Column(
        children: [
          if (title?.isNotEmpty ?? false) ...[
            Text(
              title!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
          ],
          content,
        ],
      ),
      isDense: true,
      btnOkText: okTixt,
      btnCancelText: cancelTixt,
      padding: const EdgeInsets.all(8),
      dialogBorderRadius: BorderRadius.circular(15),
      btnOkOnPress: onConfirmBtnTap,
      btnCancelOnPress: onCancelBtnTap,
      dismissOnTouchOutside: dismissOn,
      dismissOnBackKeyPress: dismissOn,
    ).show();
  }

  static Future<void> customCupertino(
    BuildContext context, {
    String? title,
    Widget? content,
    void Function()? onConfirmBtnTap,
    void Function()? onCancelBtnTap,
    String confirmBtnText = 'موافق',
    String cancelBtnText = 'إلغاء',
    Color? confirmBtnColor,
    Color? cancelBtnColor,
    bool showCancel = true,
  }) {
    dismissDialog(context);

    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: content,
        actions: [
          if (onConfirmBtnTap != null)
            CupertinoButton(
              onPressed: onConfirmBtnTap,
              color: confirmBtnColor,
              child: Text(confirmBtnText),
            ),
          if (showCancel)
            CupertinoButton(
              onPressed: (onCancelBtnTap != null)
                  ? onCancelBtnTap
                  : () => Navigator.pop(context),
              color: cancelBtnColor,
              child: Text(cancelBtnText),
            ),
        ],
      ),
    );
  }
}
