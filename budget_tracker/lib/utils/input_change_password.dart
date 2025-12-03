import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppInputChangePassword {
  static InputDecoration build(String label, IconData suffixIcon) {
    return InputDecoration(
      fillColor: Colors.white, // nền trắng
      filled: true,
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF666666)),
      suffixIcon: Icon(
        suffixIcon,
        color: const Color(0xFF999999), // xám nhạt, nhẹ mắt
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0.r),
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)), // viền xám nhẹ
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0.r),
        borderSide: const BorderSide(color: Color(0xFF4A90E2)), // màu xanh focus đẹp
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0.r),
      ),
    );
  }
}