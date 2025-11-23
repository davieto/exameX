import 'package:flutter/material.dart';

Future<void> showCustomDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = "Confirmar",
  String cancelLabel = "Cancelar",
  VoidCallback? onConfirm,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(cancelLabel.toUpperCase()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.pop(context);
              if (onConfirm != null) onConfirm();
            },
            child: Text(confirmLabel.toUpperCase()),
          ),
        ],
      );
    },
  );
}