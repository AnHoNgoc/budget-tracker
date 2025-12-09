import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmDialog {
  static Future<bool> show(
      BuildContext context, {
        required String title,
        required String content,
        String cancelText = 'Cancel',
        String confirmText = 'Confirm',
      }) async {
    return await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Padding(
          padding: EdgeInsets.only(top: 8.0.r),
          child: Text(content),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            isDestructiveAction: false,
            child: Text(cancelText),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, true),
            isDestructiveAction: true,
            child: Text(confirmText),
          ),
        ],
      ),
    ) ??
        false;
  }
}