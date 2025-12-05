
import 'package:budget_tracker/screens/sign_up.dart';
import 'package:budget_tracker/utils/app_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/auth_service.dart';
import '../utils/app_text_field.dart';
import '../utils/show_app_dialog.dart';
import 'dashboard.dart';

import 'package:flutter/cupertino.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoader = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoader = true);

    try {
      String? result = await AuthService().loginUser({
        "email": _emailController.text,
        "password": _passwordController.text,
      });

      if (!mounted) return;

      if (result == null) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => const Dashboard()),
        );
      } else {
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
                      CupertinoIcons.person_circle,
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
                SizedBox(height: 20.h),
                AppTextField(
                  controller: _passwordController,
                  placeholder: "Password",
                  isPassword: true,
                  validator: AppValidator.validatePassword,
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
                      "Login",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => const SignUpScreen()),
                    );
                  },
                  child: Text(
                    "Create New Account",
                    style: TextStyle(
                      color: const Color(0xFF3DDC97),
                      fontSize: 20.sp,
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
