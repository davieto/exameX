import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String description;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool barrierDismissible;

  const AppDialog({
    super.key,
    required this.title,
    required this.description,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.barrierDismissible = true,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String description,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (_) => AppDialog(
        title: title,
        description: description,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 420,
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                color: color.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (cancelText != null)
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onCancel?.call();
                    },
                    child: Text(cancelText!,
                        style: TextStyle(color: color.onSurfaceVariant)),
                  ),
                if (confirmText != null) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.primary,
                      foregroundColor: color.onPrimary,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm?.call();
                    },
                    child: Text(confirmText!),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}