import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      dense: true,
      title: Text(label, style: const TextStyle(fontSize: 13)),
      value: value,
      onChanged: (val) => onChanged(val ?? false),
      activeColor: Theme.of(context).colorScheme.primary,
      checkColor: Colors.white,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}