import 'package:flutter/material.dart';

class ConfirmDialog {
  /// Hiển thị dialog xác nhận với title và content tùy ý
  /// Trả về true nếu người dùng nhấn "Confirm", false nếu nhấn "Cancel"
  static Future<bool> show(
      BuildContext context, {
        required String title,
        required String content,
        String cancelText = 'Cancel',
        String confirmText = 'Confirm',
      }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    ) ??
        false; // Nếu dialog bị dismiss, trả về false
  }
}