import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, this.currentIndex = 2});

  @override
  Widget build(BuildContext context) {
    final items = [
      {"icon": LucideIcons.fileText, "label": "Provas", "route": "/prepare-provas"},
      {"icon": LucideIcons.list, "label": "Gabarito", "route": "/gabarito"},
      {"icon": LucideIcons.grid, "label": "Home", "route": "/home"},
      {"icon": LucideIcons.search, "label": "Questões", "route": "/questoes"},
      {"icon": LucideIcons.share2, "label": "Compartilhe", "route": "/compartilhe"},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            return GestureDetector(
              onTap: () => Navigator.pushNamed(context, item["route"] as String),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item["icon"] as IconData,
                      color: idx == currentIndex ? Colors.white : Colors.white70),
                  Text(
                    item["label"] as String,
                    style: TextStyle(
                      color: idx == currentIndex ? Colors.white : Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}