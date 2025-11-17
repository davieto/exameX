import 'package:flutter/material.dart';

enum InputSize { sm, md, lg }

class AppInput extends StatelessWidget {
  final String placeholder;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final InputSize size;

  const AppInput({
    super.key,
    required this.placeholder,
    this.controller,
    this.prefixIcon,
    this.size = InputSize.md,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    final double height = switch (size) {
      InputSize.sm => 36,
      InputSize.md => 42,
      InputSize.lg => 48,
    };

    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          prefixIcon:
              prefixIcon != null ? Icon(prefixIcon, size: 18, color: color.onSurfaceVariant) : null,
          hintText: placeholder,
          hintStyle: TextStyle(color: color.onSurfaceVariant.withOpacity(0.7)),
          filled: true,
          fillColor: color.surfaceVariant.withOpacity(0.25),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: color.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: color.primary),
          ),
        ),
      ),
    );
  }
}