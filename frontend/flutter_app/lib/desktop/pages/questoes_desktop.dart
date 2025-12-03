<<<<<<< HEAD
import 'package:file_picker/file_picker.dart';
=======
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/api_service.dart';
import '../layout/desktop_layout.dart';
import '../widgets/ui/app_card.dart';
import '../widgets/ui/app_input.dart';
import '../widgets/ui/app_button.dart';
<<<<<<< HEAD
import '../widgets/nova_questao_dialog.dart';
import '../widgets/visualizar_questao_dialog.dart';
=======
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c

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
<<<<<<< HEAD
      setState(() => carregando = true);
=======
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
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

<<<<<<< HEAD
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
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      final filePath = result.files.single.path;
      if (filePath != null) {
        try {
          await ApiService.importarQuestoesCsv(filePath);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Importação concluída com sucesso!')));
          await carregarQuestoes();
        } catch (e) {
          debugPrint('Erro ao importar questões: $e');
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erro ao importar CSV')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

=======
  Future<void> criarQuestaoDialog(BuildContext context) async {
    final tituloCtrl = TextEditingController();
    final dificuldadeCtrl = TextEditingController(text: "1");
    final professorCtrl = TextEditingController(text: "1");

    // Alternativas default
    final alternativas = [
      {"texto": "Alternativa A", "afirmativa": 0},
      {"texto": "Alternativa B", "afirmativa": 0},
      {"texto": "Alternativa C", "afirmativa": 0},
      {"texto": "Alternativa D", "afirmativa": 0},
      {"texto": "Alternativa E", "afirmativa": 1},
    ];

    await showDialog(
      context: context,
      builder: (ctx) {
        final color = Theme.of(context).colorScheme;
        return AlertDialog(
          title: const Text("Criar nova questão"),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tituloCtrl,
                  decoration: const InputDecoration(labelText: "Título da questão"),
                ),
                TextField(
                  controller: dificuldadeCtrl,
                  decoration: const InputDecoration(labelText: "ID Dificuldade"),
                ),
                TextField(
                  controller: professorCtrl,
                  decoration: const InputDecoration(labelText: "ID Professor"),
                ),
                const SizedBox(height: 12),
                Text("Alternativas:", style: TextStyle(color: color.onSurfaceVariant)),
                for (int i = 0; i < alternativas.length; i++)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (v) => alternativas[i]["texto"] = v,
                          decoration: InputDecoration(labelText: "Alternativa ${String.fromCharCode(65 + i)}"),
                        ),
                      ),
                      Checkbox(
                        value: alternativas[i]["afirmativa"] == 1,
                        onChanged: (val) {
                          for (final a in alternativas) {
                            a["afirmativa"] = 0;
                          }
                          setState(() {
                            alternativas[i]["afirmativa"] = val == true ? 1 : 0;
                          });
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                try {
                  await ApiService.criarQuestaoObjetiva({
                    'titulo': tituloCtrl.text,
                    'idDificuldade': int.tryParse(dificuldadeCtrl.text) ?? 1,
                    'idProfessor': int.tryParse(professorCtrl.text) ?? 1,
                    'alternativas': alternativas,
                  });
                  await carregarQuestoes();
                } catch (e) {
                  debugPrint('Erro ao criar questão: $e');
                }
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
    return DesktopLayout(
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
              // ======== Cabeçalho ========
=======
              // Cabeçalho
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
<<<<<<< HEAD
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
=======
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Banco de Questões',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold, color: color.onSurface)),
                      const SizedBox(height: 4),
                      Text('Gerencie questões objetivas e dissertativas',
                          style: TextStyle(color: color.onSurfaceVariant, fontSize: 16)),
                    ],
                  ),
                  Row(children: [
                    AppButton(
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
                      label: 'Nova Questão',
                      icon: LucideIcons.plus,
                      onPressed: () => criarQuestaoDialog(context),
                    ),
<<<<<<< HEAD
                  ]),
                ],
              ),
              const SizedBox(height: 32),

=======
                  ])
                ],
              ),
              const SizedBox(height: 32),
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
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
<<<<<<< HEAD
                      style: TextStyle(
                          color: color.onSurfaceVariant, fontSize: 16),
=======
                      style: TextStyle(color: color.onSurfaceVariant, fontSize: 16),
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
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
<<<<<<< HEAD
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
=======
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(q['titulo'] ?? 'Sem título',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600, color: color.onSurface)),
                                const SizedBox(height: 4),
                                Text(
                                    "Dificuldade ID: ${q['idDificuldade']} | Professor ID: ${q['idProfessor']}",
                                    style: TextStyle(color: color.onSurfaceVariant, fontSize: 13)),
                              ]),
                            ),
                            AppButton(
                              label: 'Excluir',
                              variant: ButtonVariant.outline,
                              icon: LucideIcons.trash2,
                              onPressed: () async {
                                await ApiService.deletarQuestao(q['id']);
                                carregarQuestoes();
                              },
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
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
<<<<<<< HEAD

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
=======
}
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
