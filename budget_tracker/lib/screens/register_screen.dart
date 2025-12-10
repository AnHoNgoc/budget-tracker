import 'package:budget_tracker/screens/login_screen.dart';
import 'package:budget_tracker/services/auth_service.dart';
import 'package:budget_tracker/utils/app_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_text_field.dart';
import '../utils/show_app_dialog.dart';
import '../utils/show_app_dialog_auto_close.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoader = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoader = true);

    var data = {
      "username": _userNameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "remainingAmount": 0,
      "totalCredit": 0,
      "totalDebit": 0,
    };

    try {
      final result = await _authService.createUser(data);

      if (!mounted) return;

      if (result == null) {
        _userNameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();

        showAppDialogAutoClose(
          context,
          message: "User created successfully!",
          onClosed: () {
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
            );
          },
        );

      } else {
        showAppDialog(context, message: result, type: DialogType.error);
      }
    } catch (e) {
      if (!mounted) return;
      showAppDialog(context, message:  'Error: $e', type: DialogType.error);
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

                /// ICON
                SizedBox(
                  height: 200.h,
                  child: Center(
                    child: Icon(
                      CupertinoIcons.person_crop_circle_fill_badge_plus,
                      size: 120.sp,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                /// Username
                AppTextField(
                  controller: _userNameController,
                  placeholder: "Username",
                  validator: AppValidator.validateUser,
                ),

                SizedBox(height: 20.h),

                /// Email
                AppTextField(
                  controller: _emailController,
                  placeholder: "Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidator.validateEmail,
                ),

                SizedBox(height: 20.h),

                /// Password
                AppTextField(
                  controller: _passwordController,
                  placeholder: "Password",
                  isPassword: true,
                  validator: AppValidator.validatePassword,
                ),

                SizedBox(height: 20.h),

                /// Confirm Password
                AppTextField(
                  controller: _confirmPasswordController,
                  placeholder: "Confirm Password",
                  isPassword: true,
                  validator: (value) =>
                      AppValidator.validateConfirmPassword(
                        value,
                        _passwordController.text,
                      ),
                ),

                SizedBox(height: 40.h),

                /// Create Button
                SizedBox(
                  height: 55.h,
                  child: CupertinoButton.filled(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(10.r),
                    onPressed: _isLoader ? null : _submitForm,
                    child: _isLoader
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                /// Go to Login
                CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: Text(
                    "Login",
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