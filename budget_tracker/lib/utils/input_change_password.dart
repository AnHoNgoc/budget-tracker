import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef ValidatorFunction = String? Function(String?);

class InputChangePassword extends FormField<String> {
  final TextEditingController controller;
  final String placeholder;
  final TextInputType keyboardType;

  InputChangePassword({
    super.key,
    required this.controller,
    required this.placeholder,
    this.keyboardType = TextInputType.text,
    super.validator,
  }) : super(
    initialValue: controller.text,
    builder: (field) {
      final obscureNotifier = ValueNotifier<bool>(true);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: obscureNotifier,
            builder: (context, obscure, _) => CupertinoTextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscure,
              placeholder: placeholder,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              suffix: Padding(
                padding: EdgeInsets.only(right: 12.w), // khoảng cách từ mép phải
                child: GestureDetector(
                  onTap: () => obscureNotifier.value = !obscure,
                  child: Icon(
                    obscure ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                    color: Colors.grey.shade600,
                    size: 22.sp,
                  ),
                ),
              ),
              style: TextStyle(color: Colors.black, fontSize: 16.sp),
              onChanged: field.didChange,
            ),
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
