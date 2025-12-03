import 'package:flutter/material.dart';

class ToastMessage {
  static void show(
    BuildContext context, {
    required String message,
    bool success = true,
    Duration duration = const Duration(seconds: 2),
  }) {
    // Usa o ScaffoldMessenger, mais seguro que Overlay manual
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      debugPrint("ToastMessage: context inválido");
      return;
    }

    final color = success ? Colors.green : Colors.redAccent;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        duration: duration,
      ),
    );
  }
}