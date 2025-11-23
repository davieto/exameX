import 'package:flutter/material.dart';

enum BadgeVariant { primary, secondary, destructive, outline }

class AppBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;

  const AppBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    Color bg;
    Color fg;
    BorderSide border;

    switch (variant) {
      case BadgeVariant.primary:
        bg = color.primary;
        fg = color.onPrimary;
        border = BorderSide.none;
        break;
      case BadgeVariant.secondary:
        bg = color.secondary;
        fg = color.onSecondary;
        border = BorderSide.none;
        break;
      case BadgeVariant.destructive:
        bg = color.error;
        fg = color.onError;
        border = BorderSide.none;
        break;
      case BadgeVariant.outline:
        bg = Colors.transparent;
        fg = color.onSurface;
        border = BorderSide(color: color.outlineVariant);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        border: Border.fromBorderSide(border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}