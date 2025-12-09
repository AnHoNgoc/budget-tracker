import 'package:flutter/cupertino.dart';

class LogoutDialog {
  static Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
    return await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            isDefaultAction: true,
            child: const Text('Cancel'), // nút chuẩn màu xanh iOS
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, true),
            isDestructiveAction: true,
            child: const Text('Log Out'), // màu đỏ chuẩn iOS
          ),
        ],
      ),
    ) ??
        false;
  }
}