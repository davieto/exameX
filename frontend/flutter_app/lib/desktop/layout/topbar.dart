import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(LucideIcons.bookOpen, size: 24),
          const SizedBox(width: 8),
          Text(
            "ExameX",
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          Text(
            "Sistema de Correção de Provas",
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          )
        ],
      ),
    );
  }
}