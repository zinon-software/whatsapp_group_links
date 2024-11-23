import 'package:flutter/material.dart';

import '../utils/color_manager.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    this.onPressed,
    this.label,
    this.backgroundColor,
    this.fontSize = 14.0,
    this.iconSize = 18.0,
    this.height = 45.0,
    this.width,
    this.radius = 12,
    this.textColor,
    this.isLoading = false,
    this.enableClick = true,
    this.enableBorder = false,
    this.borderColor,
    this.assetIcon,
    this.icon,
    this.child,
  });
  final VoidCallback? onPressed;

  final String? label;
  final Color? textColor;
  final Color? backgroundColor;
  final double fontSize;
  final double iconSize;
  final double height;
  final double? width;
  final double radius;
  final bool enableBorder;
  final Color? borderColor;
  final bool isLoading;
  final bool enableClick;
  final String? assetIcon;
  final IconData? icon;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(.5),
      decoration: BoxDecoration(
        color: !enableClick || onPressed == null
            ? Colors.grey
            : backgroundColor ?? ColorsManager.primaryLight,
        border: Border.all(
          color: !enableClick || onPressed == null
              ? Colors.grey
              : borderColor ?? backgroundColor ?? theme.primaryColor,
          width: enableBorder ? 1.0 : 0.0,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        onPressed: enableClick
            ? isLoading
                ? null
                : onPressed
            : null,
        color: enableClick ? backgroundColor : backgroundColor?.withOpacity(.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isLoading) CircularProgressIndicator(color: textColor),
            if (!isLoading)
              SizedBox(
                child: (child != null)
                    ? child
                    : Text(
                        label ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor ?? Colors.white,
                          fontSize: fontSize,
                        ),
                      ),
              ),
            if (assetIcon != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  assetIcon!,
                  height: iconSize,
                  fit: BoxFit.fill,
                  color: textColor ?? Colors.white,
                ),
              ),
            if (icon != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  icon,
                  color: textColor ?? Colors.white,
                  size: iconSize,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
