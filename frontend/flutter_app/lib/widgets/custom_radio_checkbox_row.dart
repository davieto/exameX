import 'package:flutter/material.dart';

class CustomRadioCheckboxRow extends StatelessWidget {
  final String title;
  final List<String> radios;
  final String radioValue;
  final ValueChanged<String> onRadioChanged;
  final bool check1;
  final bool check2;
  final ValueChanged<bool> onCheck1;
  final ValueChanged<bool> onCheck2;

  const CustomRadioCheckboxRow({
    super.key,
    required this.title,
    required this.radios,
    required this.radioValue,
    required this.onRadioChanged,
    required this.check1,
    required this.check2,
    required this.onCheck1,
    required this.onCheck2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...radios.map(
              (e) => Expanded(
                child: RadioListTile<String>(
                  title: Text(e),
                  dense: true,
                  value: e,
                  groupValue: radioValue,
                  onChanged: (val) => onRadioChanged(val!),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        CheckboxListTile(
          value: check1,
          onChanged: (val) => onCheck1(val ?? false),
          title: const Text("Questões Públicas"),
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
        ),
        CheckboxListTile(
          value: check2,
          onChanged: (val) => onCheck2(val ?? false),
          title: const Text("Questões Privadas"),
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
        ),
      ],
    );
  }
}