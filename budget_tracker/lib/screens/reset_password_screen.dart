import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/auth_service.dart';
import '../utils/app_text_field.dart';
import '../utils/app_validator.dart';
import '../utils/show_app_dialog.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoader = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoader = true);

    try {
      // Giả sử AuthService có method resetPassword
      String? result = await AuthService().sendPasswordResetEmail(_emailController.text.trim());
      if (result == null) {
        if (!mounted) return;
        showAppDialog(context, message: "If an account exists with this email, a reset link has been sent.!", type: DialogType.success);
        _emailController.clear();
      } else {
        if (!mounted) return;
        showAppDialog(context, message: result, type: DialogType.error);
      }
    } catch (e) {
      if (!mounted) return;
      showAppDialog(context, message: '$e', type: DialogType.error);
    } finally {
      if (mounted) setState(() => _isLoader = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF252634),
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.white, // đổi màu text thành trắng
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: 50.h),
                SizedBox(
                  height: 250.h,
                  child: Center(
                    child: Icon(
                      CupertinoIcons.lock_shield,
                      size: 120.sp,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                AppTextField(
                  controller: _emailController,
                  placeholder: "Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidator.validateEmail,
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  height: 55.h,
                  child: CupertinoButton.filled(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(10.r),
                    onPressed: _isLoader ? null : _submitForm,
                    child: _isLoader
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : Text(
                      "Send Reset Link",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}