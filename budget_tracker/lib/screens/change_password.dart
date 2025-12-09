import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/auth_service.dart';
import '../utils/app_validator.dart';
import '../utils/input_change_password.dart';
import '../utils/show_app_dialog.dart';
import '../utils/show_app_dialog_auto_close.dart';
import 'dashboard.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final result = await AuthService().changePassword(
        oldPassword: _oldPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (result == null) {
        showAppDialogAutoClose(
          context,
          message: "Password changed successfully!",
          onClosed: () {
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (_) => const Dashboard()),
                  (route) => false,
            );
          },
        );
      } else {
        showAppDialog(context, message: result, type: DialogType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.back, size: 28.sp),
            onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (_) => const Dashboard()),
                  (route) => false,
            );
          }
        ),
        middle: Text(
          'Change Password',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 25.sp,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0.r),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: 40.h),

                Image.asset(
                  'asset/images/password.png',
                  width: 150,
                  height: 170,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: 60.h),

                InputChangePassword(
                  controller: _oldPasswordController,
                  placeholder: "Old Password",
                  validator: AppValidator.validatePassword,
                ),

                SizedBox(height: 20.h),

                InputChangePassword(
                  controller: _newPasswordController,
                  placeholder: "New Password",
                  validator: (value) =>
                      AppValidator.validateNewPassword(value, _oldPasswordController.text),
                ),

                SizedBox(height: 20.h),

                InputChangePassword(
                  controller: _confirmPasswordController,
                  placeholder: "Confirm New Password",
                  validator: (value) =>
                      AppValidator.validateConfirmPassword(value, _newPasswordController.text),
                ),

                SizedBox(height: 40.h),

                CupertinoButton.filled(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(color: Colors.black) // <-- đổi màu ở đây
                      : const Text("Change Password"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}