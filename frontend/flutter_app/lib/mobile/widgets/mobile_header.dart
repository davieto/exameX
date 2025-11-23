import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MobileHeader extends StatelessWidget {
  const MobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5)],
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(LucideIcons.bookOpen,
              size: 32, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}