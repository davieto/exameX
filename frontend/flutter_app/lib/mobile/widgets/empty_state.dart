import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final String actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    this.message = "Nenhuma questão encontrada",
    this.actionLabel = "Criar nova questão",
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onAction,
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(LucideIcons.plus, size: 18),
                const SizedBox(width: 8),
                Text(
                  actionLabel.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}