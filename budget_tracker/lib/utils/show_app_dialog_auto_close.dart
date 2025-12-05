import 'package:flutter/cupertino.dart';

void showAppDialogAutoClose(
    BuildContext context, {
      required String message,
      Duration duration = const Duration(milliseconds: 1500),
      VoidCallback? onClosed,
    }) {
  // Lấy Navigator trước async gap (đúng chuẩn)
  final navigator = Navigator.of(context);

  showCupertinoDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CupertinoAlertDialog(
      title: const Text("Success"),
      content: Text(message),
    ),
  );

  Future.delayed(duration, () {
    if (navigator.canPop()) {
      navigator.pop(); // dùng navigator đã lấy → không vi phạm lint
    }
    if (onClosed != null) onClosed();
  });
}