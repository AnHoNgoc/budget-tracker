import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum DialogType { error, success, warning }

void showAppDialog(
    BuildContext context, {
      required String message,
      String? title,
      DialogType type = DialogType.success,
    }) {
  // Chọn tiêu đề mặc định theo type
  final defaultTitle = title ??
      (type == DialogType.error
          ? "Error"
          : type == DialogType.warning
          ? "Warning"
          : "Success");

  // Icon hoặc màu có thể tùy chỉnh theo type
  final titleWidget = Row(
    children: [
      Icon(
        type == DialogType.error
            ? CupertinoIcons.clear_circled
            : type == DialogType.success
            ? CupertinoIcons.check_mark_circled
            : CupertinoIcons.exclamationmark_triangle,
        color: type == DialogType.error
            ? Colors.red
            : type == DialogType.success
            ? Colors.green
            : Colors.orange,
      ),
      const SizedBox(width: 8),
      Text(defaultTitle),
    ],
  );

  showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: titleWidget,
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          child: const Text("OK"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}