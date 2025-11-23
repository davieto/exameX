import 'package:flutter/material.dart';

class AppTooltip extends StatelessWidget {
  final Widget child;
  final String message;
  const AppTooltip({super.key, required this.child, required this.message});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1024) return child;

        return Tooltip(
          message: message,
          waitDuration: const Duration(milliseconds: 400),
          textStyle: TextStyle(color: color.onPrimary),
          decoration: BoxDecoration(
            color: color.onSurface.withOpacity(0.85),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: child,
        );
      },
    );
  }
}