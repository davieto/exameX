import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../layout/desktop_layout.dart';
import '../widgets/ui/app_button.dart';
import '../widgets/ui/app_input.dart';
import '../widgets/ui/app_card.dart';

class AvaliacoesDesktopPage extends StatelessWidget {
  const AvaliacoesDesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth < 1024) return const SizedBox.shrink();

      return DesktopLayout(
        content: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Avaliações',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: color.onBackground)),
                          const SizedBox(height: 4),
                          Text('Gerencie suas provas e avaliações',
                              style: TextStyle(
                                  color: color.onSurfaceVariant, fontSize: 16)),
                        ]),
                    AppButton(
                      label: 'Nova Avaliação',
                      icon: LucideIcons.plus,
                      variant: ButtonVariant.primary,
                      onPressed: () {},
                    )
                  ],
                ),
                const SizedBox(height: 32),
                const AppInput(
                  placeholder: 'Pesquisar avaliações...',
                  prefixIcon: LucideIcons.search,
                ),
                const SizedBox(height: 32),
                AppCard(
                  color: color.surfaceVariant.withOpacity(0.15),
                  padding:
                      const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: color.primary.withOpacity(0.1),
                        child: Icon(LucideIcons.fileText,
                            color: color.primary, size: 36),
                      ),
                      const SizedBox(height: 16),
                      Text('Nenhuma avaliação cadastrada',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: color.onBackground)),
                      const SizedBox(height: 8),
                      SizedBox(
                          width: 520,
                          child: Text(
                              'Comece criando sua primeira avaliação. Você poderá adicionar questões do banco de dados ou criar novas.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: color.onSurfaceVariant, fontSize: 14))),
                      const SizedBox(height: 24),
                      AppButton(
                        label: 'Criar Primeira Avaliação',
                        icon: LucideIcons.plus,
                        onPressed: () {},
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}