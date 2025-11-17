import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../layout/desktop_layout.dart';
import '../widgets/ui/app_card.dart';
import '../widgets/ui/app_button.dart';

class HomeDesktopPage extends StatelessWidget {
  const HomeDesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    final features = [
      {
        'icon': LucideIcons.fileText,
        'title': 'Criar Avaliações',
        'desc': 'Crie provas personalizadas com questões do banco ou novas questões',
        'action': 'Gerenciar Avaliações',
        'path': '/avaliacoes',
      },
      {
        'icon': LucideIcons.helpCircle,
        'title': 'Banco de Questões',
        'desc': 'Gerencie questões por disciplina e dificuldade',
        'action': 'Acessar Questões',
        'path': '/questoes',
      },
      {
        'icon': LucideIcons.qrCode,
        'title': 'Leitura de QR Code',
        'desc': 'Corrija provas automaticamente através da leitura de QR codes',
        'action': 'Escanear Provas',
        'path': '/gabaritos',
      },
      {
        'icon': LucideIcons.barChart3,
        'title': 'Relatórios e Estatísticas',
        'desc': 'Visualize dashboards de desempenho por turma',
        'action': 'Ver Relatórios',
        'path': '/relatorios',
      },
    ];

    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth < 1024) return const SizedBox.shrink();

      return DesktopLayout(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo ao ExameX',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.onBackground,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sistema completo para criação, correção e análise de avaliações',
              style:
                  TextStyle(color: color.onSurfaceVariant, fontSize: 16),
            ),
            const SizedBox(height: 24),

            // === grid de cards ===
            Expanded(
              child: GridView.builder(
                itemCount: features.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                itemBuilder: (_, i) {
                  final f = features[i];
                  return AppCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor:
                              color.primary.withOpacity(0.1),
                          child: Icon(f['icon'] as IconData,
                              color: color.primary, size: 24),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f['title'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: color.onBackground)),
                            const SizedBox(height: 8),
                            Text(f['desc'] as String,
                                style: TextStyle(
                                    color: color.onSurfaceVariant,
                                    fontSize: 14)),
                          ],
                        ),
                        AppButton(
                          fullWidth: true,
                          label: f['action'] as String,
                          icon: LucideIcons.arrowRight,
                          onPressed: () =>
                              Navigator.pushNamed(context, f['path'] as String),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}