import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../layout/desktop_layout.dart';
import '../widgets/ui/app_button.dart';
import '../widgets/ui/app_input.dart';
import '../widgets/ui/app_card.dart';

class QuestoesDesktopPage extends StatelessWidget {
  const QuestoesDesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return LayoutBuilder(builder: (context, c) {
      // exibir só em telas desktop
      if (c.maxWidth < 1024) return const SizedBox.shrink();

      return DesktopLayout(
        content: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== cabeçalho =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Banco de Questões',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: color.onBackground)),
                          const SizedBox(height: 4),
                          Text('Gerencie questões por disciplina e dificuldade',
                              style: TextStyle(
                                  color: color.onSurfaceVariant, fontSize: 16)),
                        ]),
                    Row(children: [
                      AppButton(
                        label: 'Importar CSV',
                        icon: LucideIcons.upload,
                        variant: ButtonVariant.outline,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 12),
                      AppButton(
                        label: 'Nova Questão',
                        icon: LucideIcons.plus,
                        onPressed: () {},
                      ),
                    ])
                  ],
                ),
                const SizedBox(height: 32),

                // ===== busca + filtro =====
                Row(children: [
                  const Expanded(
                    flex: 2,
                    child: AppInput(
                      prefixIcon: LucideIcons.search,
                      placeholder: 'Pesquisar questões...',
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: AppInput(
                      placeholder: 'Filtrar por disciplina...',
                    ),
                  ),
                ]),
                const SizedBox(height: 40),

                // ===== card vazio =====
                AppCard(
                  color: color.surfaceVariant.withOpacity(0.2),
                  padding:
                      const EdgeInsets.symmetric(vertical: 80, horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: color.primary.withOpacity(0.1),
                        child: Icon(LucideIcons.helpCircle,
                            color: color.primary, size: 36),
                      ),
                      const SizedBox(height: 16),
                      Text('Nenhuma questão cadastrada',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: color.onBackground)),
                      const SizedBox(height: 8),
                      SizedBox(
                          width: 500,
                          child: Text(
                              'Comece adicionando questões ao banco de dados. Você pode criar manualmente ou importar via CSV.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: color.onSurfaceVariant, fontSize: 14))),
                      const SizedBox(height: 24),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppButton(
                              label: 'Importar CSV',
                              icon: LucideIcons.upload,
                              variant: ButtonVariant.outline,
                              onPressed: () {},
                            ),
                            const SizedBox(width: 12),
                            AppButton(
                              label: 'Criar Questão',
                              icon: LucideIcons.plus,
                              onPressed: () {},
                            ),
                          ])
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // ===== formato CSV =====
                AppCard(
                    color: color.surfaceVariant.withOpacity(0.2),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Formato para importação CSV',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: color.onBackground)),
                          const SizedBox(height: 12),
                          Text('Use o seguinte formato para importar questões:',
                              style: TextStyle(color: color.onSurfaceVariant)),
                          const SizedBox(height: 16),
                          AppCard(
                              color: color.surface,
                              padding: const EdgeInsets.all(16),
                              shadow: false,
                              child: const Text(
                                'Questão // Nível de Dificuldade // Valor // Disciplina // Alternativa A // Alternativa B // Alternativa C // Alternativa D // Alternativa E // Resposta Correta',
                                style: TextStyle(
                                    fontSize: 13, fontFamily: 'monospace'),
                              )),
                          const SizedBox(height: 12),
                          Text(
                              'Nota: Suporte a imagens disponível através de URLs na questão.',
                              style: TextStyle(
                                  color: color.onSurfaceVariant, fontSize: 13))
                        ]))
              ],
            ),
          ),
        ),
      );
    });
  }
}