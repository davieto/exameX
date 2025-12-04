import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/api_service.dart';
import '../layout/desktop_layout.dart';
import '../widgets/ui/app_card.dart';

class RelatoriosDesktopPage extends StatefulWidget {
  const RelatoriosDesktopPage({super.key});

  @override
  State<RelatoriosDesktopPage> createState() => _RelatoriosDesktopPageState();
}

class _RelatoriosDesktopPageState extends State<RelatoriosDesktopPage> {
  bool carregando = true;
  Map<String, dynamic> estatisticas = {};

  @override
  void initState() {
    super.initState();
    carregarEstatisticas();
  }

  /// ====== Carregar dados do backend ======
  Future<void> carregarEstatisticas() async {
    try {
      setState(() => carregando = true);
      final data = await ApiService.estatisticasTurma(1); // Turma padrão = 1
      setState(() {
        estatisticas = data;
        carregando = false;
      });
    } catch (e) {
      debugPrint('Erro ao buscar estatísticas: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Erro ao carregar estatísticas.')));
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, c) {
        if (c.maxWidth < 1024) return const SizedBox.shrink();

        return DesktopLayout(
          content: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: carregando
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ===== Títulos =====
                          Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Relatórios e Estatísticas',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: color.onSurface)),
                                const SizedBox(height: 6),
                                Text('Acompanhe o desempenho das turmas e avaliações',
                                    style: TextStyle(
                                        color: color.onSurfaceVariant,
                                        fontSize: 16)),
                              ],
                            ),
                          ),

                          // ===== KPIs =====
                          GridView.count(
                              crossAxisCount: 4,
                              shrinkWrap: true,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _Metric(
                                  'Total de Provas',
                                  (estatisticas['total_provas'] ?? 0).toString(),
                                  LucideIcons.fileText,
                                ),
                                const _Metric('Turmas Ativas', '1', LucideIcons.users),
                                _Metric(
                                  'Média Geral',
                                  ((estatisticas['media_geral'] ?? 0) as num)
                                      .toStringAsFixed(2),
                                  LucideIcons.trendingUp,
                                ),
                                const _Metric(
                                    'Taxa de Aprovação', '-%', LucideIcons.barChart3),
                              ]),
                          const SizedBox(height: 40),

                          // ===== Simples gráfico placeholder =====
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                            physics: const NeverScrollableScrollPhysics(),
                            children: const [
                              _Chart('Desempenho por Turma', LucideIcons.barChart3),
                              _Chart('Distribuição de Notas', LucideIcons.trendingUp),
                            ],
                          ),
                          const SizedBox(height: 32),
                          const _Chart('Análise de Questões', LucideIcons.fileText, 280),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ===== componente KPI =====
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                        color: color.onSurface)),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color.primary, size: 24),
          )
        ],
      ),
    );
  }
}

// ===== componente gráfico (placeholder) =====
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                        fontWeight: FontWeight.w600, color: color.onSurface)),
          ),
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
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}