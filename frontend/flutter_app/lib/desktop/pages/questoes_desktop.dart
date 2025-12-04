import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/api_service.dart';
import '../layout/desktop_layout.dart';
import '../widgets/ui/app_card.dart';
import '../widgets/ui/app_input.dart';
import '../widgets/ui/app_button.dart';
import '../widgets/nova_questao_dialog.dart';
import '../widgets/visualizar_questao_dialog.dart';

class QuestoesDesktopPage extends StatefulWidget {
  const QuestoesDesktopPage({super.key});

  @override
  State<QuestoesDesktopPage> createState() => _QuestoesDesktopPageState();
}

class _QuestoesDesktopPageState extends State<QuestoesDesktopPage> {
  bool carregando = true;
  List<dynamic> questoes = [];

  @override
  void initState() {
    super.initState();
    carregarQuestoes();
  }

  Future<void> carregarQuestoes() async {
    try {
      setState(() => carregando = true);
      final lista = await ApiService.listarQuestoes();
      setState(() {
        questoes = lista;
        carregando = false;
      });
    } catch (e) {
      debugPrint('Erro ao buscar questões: $e');
      setState(() => carregando = false);
    }
  }

  /// ======== CRIAÇÃO DE QUESTÃO (nova tela completa) =========
  Future<void> criarQuestaoDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => NovaQuestaoDialog(
        open: true,
        onOpenChange: (open) async {
          if (!open) {
            Navigator.pop(context);
            // Atualiza o banco de questões depois de criar
            await carregarQuestoes();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Questão criada com sucesso!')),
            );
          }
        },
      ),
    );
  }

  /// ======== IMPORTAÇÃO CSV =========
 Future<void> importarQuestoes() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv', 'xlsx', 'xls'],
  );
  if (result == null) return;

  final filePath = result.files.single.path;
  if (filePath == null) return;

  try {
    await ApiService.importarQuestoes(filePath);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Importação concluída com sucesso!')),
    );
    await carregarQuestoes();
  } catch (e) {
    debugPrint('Erro ao importar: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao importar: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return DesktopLayout(
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ======== Cabeçalho ========
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
                                    color: color.onSurface)),
                        const SizedBox(height: 4),
                        Text('Gerencie suas questões objetivas',
                            style: TextStyle(
                                color: color.onSurfaceVariant, fontSize: 15)),
                      ]),
                  Row(children: [
                    AppButton(
                      label: 'Importar CSV',
                      icon: LucideIcons.upload,
                      onPressed: importarQuestoes,
                    ),
                    const SizedBox(width: 10),
                    AppButton(
                      label: 'Nova Questão',
                      icon: LucideIcons.plus,
                      onPressed: () => criarQuestaoDialog(context),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 32),

              AppInput(
                prefixIcon: LucideIcons.search,
                placeholder: 'Pesquisar questões...',
                onChanged: (_) {},
              ),
              const SizedBox(height: 24),

              if (carregando)
                const Center(child: CircularProgressIndicator())
              else if (questoes.isEmpty)
                AppCard(
                  padding: const EdgeInsets.all(40),
                  color: color.surfaceContainerHighest.withOpacity(0.2),
                  child: Center(
                    child: Text(
                      "Nenhuma questão cadastrada",
                      style: TextStyle(
                          color: color.onSurfaceVariant, fontSize: 16),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: questoes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final q = questoes[i];
                      return AppCard(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(q['titulo'] ?? 'Sem título',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: color.onSurface,
                                            )),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Dificuldade ID: ${q['idDificuldade']} | Professor ID: ${q['idProfessor']}",
                                      style: TextStyle(
                                          color: color.onSurfaceVariant,
                                          fontSize: 13),
                                    ),
                                  ]),
                            ),
                            Row(
                              children: [
                                AppButton(
                                  label: 'Visualizar',
                                  variant: ButtonVariant.ghost,
                                  icon: LucideIcons.eye,
                                  onPressed: () =>
                                      visualizarQuestao(context, q),
                                ),
                                const SizedBox(width: 8),
                                AppButton(
                                  label: 'Duplicar',
                                  variant: ButtonVariant.outline,
                                  icon: LucideIcons.copy,
                                  onPressed: () => duplicarQuestao(context, q),
                                ),
                                const SizedBox(width: 8),
                                AppButton(
                                  label: 'Excluir',
                                  variant: ButtonVariant.outline,
                                  icon: LucideIcons.trash2,
                                  onPressed: () async {
                                    try {
                                      await ApiService.deletarQuestao(
                                          q['idQuestaoObjetiva']);
                                      await carregarQuestoes();
                                    } catch (e) {
                                      debugPrint('Erro ao excluir questão: $e');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Erro ao excluir questão')));
                                    }
                                  },
                                ),
                              ],
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
  }

  /// === VISUALIZAR QUESTÃO ===
  void visualizarQuestao(BuildContext context, dynamic questao) async {
    await showDialog(
      context: context,
      builder: (_) => VisualizarQuestaoDialog(questao: questao),
    );
  }

  /// === DUPLICAR QUESTÃO ===
  void duplicarQuestao(BuildContext context, dynamic questao) async {
    await showDialog(
      context: context,
      builder: (_) => NovaQuestaoDialog(
        open: true,
        onOpenChange: (open) async {
          if (!open) {
            Navigator.pop(context);
            await carregarQuestoes();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Questão duplicada com sucesso!')),
            );
          }
        },
        questaoOriginal: questao,
      ),
    );
  }
}
