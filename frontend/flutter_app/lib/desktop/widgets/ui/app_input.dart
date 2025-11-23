import 'package:flutter/material.dart';

enum InputSize { sm, md, lg }

class AppInput extends StatelessWidget {
  final String placeholder;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  const AppInput({
    super.key,
    required this.placeholder,
    this.prefixIcon,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: placeholder,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: color.outline) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}