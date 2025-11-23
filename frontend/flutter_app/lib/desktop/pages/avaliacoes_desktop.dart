import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../layout/desktop_layout.dart';
import '../widgets/ui/app_button.dart';
import '../widgets/ui/app_input.dart';
import '../widgets/ui/app_card.dart';
import '../../services/api_service.dart';

class AvaliacoesDesktopPage extends StatefulWidget {
  const AvaliacoesDesktopPage({super.key});

  @override
  State<AvaliacoesDesktopPage> createState() => _AvaliacoesDesktopPageState();
}

class _AvaliacoesDesktopPageState extends State<AvaliacoesDesktopPage> {
  List<dynamic> provas = [];
  bool carregando = true;
  final _buscarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarProvas();
  }

  Future<void> carregarProvas() async {
    try {
      final lista = await ApiService.listarProvas();
      setState(() {
        provas = lista;
        carregando = false;
      });
    } catch (e) {
      debugPrint('Erro ao carregar provas: $e');
      setState(() => carregando = false);
    }
  }

  Future<void> criarProva() async {
    await ApiService.criarProva(
      'Nova Avaliação Automática',
      'Criada pelo Flutter Desktop',
    );
    carregarProvas();
  }

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
                // ===== Cabeçalho =====
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
                                      color: color.onSurface)),
                          const SizedBox(height: 4),
                          Text('Gerencie suas provas e avaliações',
                              style: TextStyle(
                                  color: color.onSurfaceVariant, fontSize: 16)),
                        ]),
                    AppButton(
                      label: 'Nova Avaliação',
                      icon: LucideIcons.plus,
                      onPressed: criarProva, // 🔄 integração real
                    )
                  ],
                ),
                const SizedBox(height: 32),

                // ===== Campo de busca =====
                AppInput(
                  placeholder: 'Pesquisar avaliações...',
                  prefixIcon: LucideIcons.search,
                  controller: _buscarController,
                ),
                const SizedBox(height: 32),

                // ===== Conteúdo Dinâmico =====
                if (carregando)
                  const Center(child: CircularProgressIndicator())
                else if (provas.isEmpty)
                  AppCard(
                    color: color.surfaceContainerHighest.withOpacity(0.15),
                    padding: const EdgeInsets.symmetric(
                        vertical: 80, horizontal: 24),
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
                                    color: color.onSurface)),
                        const SizedBox(height: 8),
                        SizedBox(
                            width: 520,
                            child: Text(
                                'Comece criando sua primeira avaliação. Você poderá adicionar questões do banco de dados ou criar novas.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: color.onSurfaceVariant,
                                    fontSize: 14))),
                        const SizedBox(height: 24),
                        AppButton(
                          label: 'Criar Primeira Avaliação',
                          icon: LucideIcons.plus,
                          onPressed: criarProva, // 🔄 integração real
                        )
                      ],
                    ),
                  )
                else
                  // ===== Lista de avaliações =====
                  Expanded(
                    child: ListView.separated(
                      itemCount: provas.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, i) {
                        final prova = provas[i];
                        return AppCard(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(prova['titulo']?.toString() ??
                                          'Sem título'),
                                      const SizedBox(height: 4),
                                      Text(
                                        prova['descricao']?.toString() ?? '',
                                        style: TextStyle(
                                          color: color.onSurfaceVariant,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ]),
                              ),
                              AppButton(
                                label: 'Ver Detalhes',
                                variant: ButtonVariant.outline,
                                onPressed: () {
                                  // futuro: navegar para tela de detalhes
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}