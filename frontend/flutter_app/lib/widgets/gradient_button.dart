import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final VoidCallback onPressed;
  final bool darkText;

  const GradientButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.darkText = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = darkText ? Colors.black : Colors.white;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF9B1C3F), Color(0xFFB23359)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}