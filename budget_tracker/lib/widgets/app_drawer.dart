import 'package:budget_tracker/screens/change_password.dart';
import 'package:budget_tracker/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/login.dart';
import '../services/auth_service.dart';
import '../utils/confirm_dialog.dart';
import '../utils/password_dialog.dart';
import '../utils/show_snackbar.dart';

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

  void onResetButtonPressed(String userId) async {
    // 1. Show confirm dialog và await, cần context
    bool confirmed = await ConfirmDialog.show(
      context,
      title: 'Reset Amounts',
      content: 'Are you sure you want to reset all amounts?',
      cancelText: 'Cancel',
      confirmText: 'Reset',
    );

    if (!mounted || !confirmed) return; // check mounted

    // 2. Thực hiện async, không dùng context
    bool success = await AuthService().resetAmounts(userId);

    if (!mounted) return; // check mounted trước khi dùng context

    // 3. Dùng context sau khi chắc chắn mounted
    showAppSnackBar(context,
        success ? 'User data reset successfully' : 'Error resetting user data',
        success ? Colors.green : Colors.red);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Dashboard()),
      );
    }
  }


  void onDeleteAccountPressed() async {

    bool confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete Account',
      content: 'Are you sure you want to delete your account? This action cannot be undone.',
      cancelText: 'Cancel',
      confirmText: 'Delete',
    );

    if (!mounted || !confirmed) return;

    // 2. Nếu cần password để re-authenticate, show dialog nhập password ở đây
    String? password = await PasswordDialog.show(context);

    // 3. Gọi service xóa tài khoản
    bool success = await AuthService().deleteUser(password: password);

    if (!mounted) return;

    // 4. Hiển thị snackbar và điều hướng về LoginScreen nếu xóa thành công
    if (success) {
      showAppSnackBar(context, 'Account deleted successfully', Colors.green);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      showAppSnackBar(context, 'Error deleting account', Colors.red);
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
                showAppSnackBar(context, 'No user is signed in', Colors.red);
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