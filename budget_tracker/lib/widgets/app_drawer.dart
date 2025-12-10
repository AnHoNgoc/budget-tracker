import 'package:budget_tracker/screens/change_password.dart';
import 'package:budget_tracker/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';
import '../utils/confirm_dialog.dart';
import '../utils/password_dialog.dart';
import '../utils/show_app_dialog.dart';
import '../utils/show_app_dialog_auto_close.dart';

class AppDrawer extends StatefulWidget {
  final VoidCallback onLogout;

  const AppDrawer({super.key, required this.onLogout});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  void changePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
    );
  }

  Future<void> onResetButtonPressed(String userId) async {
    // 1. Hiển thị confirm dialog và await
    final bool confirmed = await ConfirmDialog.show(
      context,
      title: 'Reset Amounts',
      content: 'Are you sure you want to reset all amounts?',
      cancelText: 'Cancel',
      confirmText: 'Reset',
    );

    if (!mounted || !confirmed) return;

    // 2. Thực hiện async reset amounts, không dùng context
    bool success = false;
    try {
      success = await AuthService().resetAmounts(userId);
    } catch (e) {
      success = false;
    }

    if (!mounted) return;

    if (success) {
       showAppDialogAutoClose(
        context,
        message: 'User data reset successfully!',
        onClosed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Dashboard()),
          );
        },
      );
    } else {
      showAppDialog(
        context,
        message: 'Error resetting user data',
        type: DialogType.error,
      );
    }
  }

  Future<void> onDeleteAccountPressed() async {
    // 1. Confirm trước khi xóa
    final bool confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete Account',
      content: 'Are you sure you want to delete your account? This action cannot be undone.',
      cancelText: 'Cancel',
      confirmText: 'Delete',
    );

    if (!mounted || !confirmed) return;

    // 2. Nếu cần password để re-authenticate
    final String? password = await PasswordDialog.show(context);

    // Nếu user hủy hoặc không nhập password
    if (!mounted || password == null || password.isEmpty) return;

    // 3. Gọi service xóa tài khoản
    bool success = false;
    try {
      success = await AuthService().deleteUser(password: password);
    } catch (e) {
      success = false;
    }

    if (!mounted) return;

    // 4. Hiển thị dialog dựa trên kết quả
    if (success) {
       showAppDialogAutoClose(
        context,
        message: 'Account deleted successfully!',
        onClosed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
      );
    } else {
       showAppDialog(
        context,
        message: 'Error deleting account',
        type: DialogType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white12),
            child: Center(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28.sp, // chữ to hơn
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Các menu item khác
          ListTile(
            leading: const Icon(Icons.padding_rounded),
            title: Text('Change Password', style: TextStyle(fontSize: 18.sp)),
            onTap: () => changePassword(context),
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title:Text('Reset Amount', style: TextStyle(fontSize: 18.sp)),
            onTap: () {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                onResetButtonPressed(user.uid);
              } else {
                showAppDialog(
                  context,
                  message: 'No user is signed in',
                  type: DialogType.error,
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('Delete Account', style: TextStyle(fontSize: 18.sp)),
            onTap: onDeleteAccountPressed,
          ),

          const Spacer(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold), // chữ to hơn
            ),
            onTap: widget.onLogout,
          ),
        ],
      ),
    );
  }
}