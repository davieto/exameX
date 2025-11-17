import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../layout/desktop_layout.dart';
import '../widgets/ui/app_button.dart';
import '../widgets/ui/app_input.dart';
import '../widgets/ui/app_card.dart';
import '../widgets/ui/app_badge.dart';
import '../widgets/ui/app_tabs.dart';
import '../widgets/ui/app_accordion.dart';

class UIPreviewDesktopPage extends StatelessWidget {
  const UIPreviewDesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth < 1024) return const SizedBox.shrink();

      return DesktopLayout(
        content: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            Text('🎨  UI Kit Preview',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 32),

            // Buttons
            Wrap(spacing: 16, runSpacing: 16, children: const [
              AppButton(label: 'Primary'),
              AppButton(label: 'Outline', variant: ButtonVariant.outline),
              AppButton(label: 'Ghost', variant: ButtonVariant.ghost),
            ]),
            const SizedBox(height: 32),

            // Input
            const AppInput(
              placeholder: 'Campo de texto',
              prefixIcon: LucideIcons.search,
            ),
            const SizedBox(height: 32),

            // Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Card Default'),
                  SizedBox(height: 8),
                  Text('Isto é um card com AppCard e border padrão.'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Badge
            Wrap(
              spacing: 12,
              children: const [
                AppBadge(label: 'Default'),
                AppBadge(label: 'Secondary', variant: BadgeVariant.secondary),
                AppBadge(label: 'Destructive', variant: BadgeVariant.destructive),
                AppBadge(label: 'Outline', variant: BadgeVariant.outline),
              ],
            ),
            const SizedBox(height: 32),

            // Tabs
            const AppTabs(tabs: ['Aba 1', 'Aba 2', 'Aba 3']),
            const SizedBox(height: 32),

            // Accordion
            const AppAccordion(
              title: 'Accordion Demo',
              content: Text(
                'Conteúdo expandido idêntico ao Accordion do Shadcn/Tailwind.',
              ),
            ),
          ],
        ),
      );
    });
  }
}