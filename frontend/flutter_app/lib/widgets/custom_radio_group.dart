import 'package:flutter/material.dart';

class CustomRadioGroup extends StatelessWidget {
  final String title;
  final String groupValue;
  final List<String> values;
  final ValueChanged<String> onChanged;

  const CustomRadioGroup({
    super.key,
    required this.title,
    required this.groupValue,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 4),
        ...values.map(
          (value) => RadioListTile<String>(
            dense: true,
            value: value,
            groupValue: groupValue,
            title: Text(value, style: const TextStyle(fontSize: 13)),
            onChanged: (val) => onChanged(val!),
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}