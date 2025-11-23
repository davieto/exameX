import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
// navegação existente

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final items = [
      {'icon': LucideIcons.home, 'label': 'Início', 'path': '/'},
      {'icon': LucideIcons.fileText, 'label': 'Avaliações', 'path': '/avaliacoes'},
      {'icon': LucideIcons.clipboardCheck, 'label': 'Gabaritos', 'path': '/gabaritos'},
      {'icon': LucideIcons.helpCircle, 'label': 'Questões', 'path': '/questoes'},
      {'icon': LucideIcons.barChart3, 'label': 'Relatórios', 'path': '/relatorios'},
    ];

    return Container(
      width: 240,
      color: colorScheme.surface,
      child: Column(
        children: [
          Container(
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Text(
              "ExameX",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                return ListTile(
                  leading: Icon(item['icon'] as IconData, color: colorScheme.primary),
                  title: Text(item['label'] as String),
                  onTap: () => Navigator.pushNamed(context, item['path'] as String),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}