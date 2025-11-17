import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../layout/desktop_layout.dart';
import '../widgets/ui/app_card.dart';

class RelatoriosDesktopPage extends StatelessWidget {
  const RelatoriosDesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth < 1024) return const SizedBox.shrink();

      return DesktopLayout(
          content: Center(
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child:
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Relatórios e Estatísticas',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: color.onBackground)),
                    const SizedBox(height: 6),
                    Text('Acompanhe o desempenho das turmas e avaliações',
                        style: TextStyle(
                            color: color.onSurfaceVariant, fontSize: 16))
                  ])),
              // KPIs
              GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    _Metric('Total de Provas', '0', LucideIcons.fileText),
                    _Metric('Turmas Ativas', '0', LucideIcons.users),
                    _Metric('Média Geral', '-', LucideIcons.trendingUp),
                    _Metric('Taxa de Aprovação', '-%', LucideIcons.barChart3)
                  ]),
              const SizedBox(height: 40),
              // gráficos
              GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    _Chart('Desempenho por Turma', LucideIcons.barChart3),
                    _Chart('Distribuição de Notas', LucideIcons.trendingUp)
                  ]),
              const SizedBox(height: 32),
              const _Chart('Análise de Questões', LucideIcons.fileText, 280)
            ])),
      ));
    });
  }
}

// ===== componentes internos =====
class _Metric extends StatelessWidget {
  const _Metric(this.title, this.value, this.icon);

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return AppCard(
        padding: const EdgeInsets.all(24),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 14,
                        color: color.onSurfaceVariant,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text(value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color.onBackground))
              ])),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: color.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50)),
            alignment: Alignment.center,
            child: Icon(icon, color: color.primary, size: 24),
          )
        ]));
  }
}

class _Chart extends StatelessWidget {
  const _Chart(this.title, this.icon, [this.height = 300]);

  final String title;
  final IconData icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return AppCard(
        padding: EdgeInsets.zero,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.all(16),
              child: Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color.onBackground))),
          const Divider(height: 0),
          SizedBox(
              height: height,
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Icon(icon,
                        size: 48,
                        color: color.onSurfaceVariant.withOpacity(0.2)),
                    const SizedBox(height: 8),
                    Text('Nenhum dado disponível ainda',
                        style: TextStyle(
                            color: color.onSurfaceVariant, fontSize: 14))
                  ])))
        ]));
  }
}