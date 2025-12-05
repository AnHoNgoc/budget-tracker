import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef ValidatorFunction = String? Function(String?);

class AppTextField extends FormField<String> {
  final TextEditingController controller;
  final String placeholder;
  final bool isPassword;
  final TextInputType keyboardType;

  AppTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    super.validator,
  }) : super(
    initialValue: controller.text,
    builder: (field) {
      final obscureNotifier = ValueNotifier<bool>(isPassword);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: obscureNotifier,
            builder: (context, obscure, _) {
              return CupertinoTextField(
                controller: controller,
                keyboardType: keyboardType,
                obscureText: obscure,
                placeholder: placeholder,
                placeholderStyle: const TextStyle(color: Color(0xFF949494)),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xAA494A59),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0x35949494)),
                ),
                suffix: isPassword
                    ? Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: GestureDetector(
                    onTap: () => obscureNotifier.value = !obscureNotifier.value,
                    child: Icon(
                      obscure ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                      color: const Color(0xFF949494),
                      size: 22.sp,
                    ),
                  ),
                )
                    : null,
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
                onChanged: (value) => field.didChange(value),
              );
            },
          ),
          if (field.errorText != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h, left: 8.w),
              child: Text(
                field.errorText!,
                style: TextStyle(
                  color: CupertinoColors.systemRed,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
        ],
      );
    },
  );
}


