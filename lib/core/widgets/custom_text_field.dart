import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final Function()? onTap;
  final bool isNotValidator;
  final Widget? widget;
  final String? Function(String?)? validator;
  final String? initialValue;
  final Function(String?)? onSaved;
  final int maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;

  const CustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
    this.isNotValidator = false,
    this.validator,
    this.widget,
    this.initialValue,
    this.onSaved,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      onTapOutside: (__) => FocusScope.of(context).unfocus(),
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      onTap: onTap,
      onSaved: onSaved,
      textAlign: TextAlign.right,
      maxLines: maxLines,
      maxLength: maxLength,
      textInputAction: textInputAction,
      textDirection: keyboardType == TextInputType.number
          ? TextDirection.ltr
          : TextDirection.rtl,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        filled: true, // جعل الحقل مملوء بلون
        fillColor: Colors.grey[200], // لون الخلفية

        border: OutlineInputBorder(
          // شكل الحاشية
          borderRadius: BorderRadius.circular(10.0), // تقريب الحواف
          borderSide: BorderSide.none, // إخفاء الحاشية الافتراضية
        ),
        focusedBorder: OutlineInputBorder(
          // شكل الحاشية عندما يكون الحقل في الفوكس
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blue), // لون الحاشية
        ),
        enabledBorder: OutlineInputBorder(
          // شكل الحاشية عندما يكون الحقل غير في الفوكس
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey), // لون الحاشية
        ),
        suffixIcon: widget,
      ),
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator ??
          (value) {
            if (isNotValidator) {
              return null;
            }
            if (value!.isEmpty) {
              return "هذا الحقل مطلوب";
            } else {
              return null;
            }
          },
    );
  }
}
