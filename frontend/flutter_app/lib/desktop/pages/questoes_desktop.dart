import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/api_service.dart';
import '../layout/desktop_layout.dart';
import '../widgets/ui/app_card.dart';
import '../widgets/ui/app_input.dart';
import '../widgets/ui/app_button.dart';

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
    return DesktopLayout(
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
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
                              ?.copyWith(fontWeight: FontWeight.bold, color: color.onSurface)),
                      const SizedBox(height: 4),
                      Text('Gerencie questões objetivas e dissertativas',
                          style: TextStyle(color: color.onSurfaceVariant, fontSize: 16)),
                    ],
                  ),
                  Row(children: [
                    AppButton(
                      label: 'Nova Questão',
                      icon: LucideIcons.plus,
                      onPressed: () => criarQuestaoDialog(context),
                    ),
                  ])
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
                      style: TextStyle(color: color.onSurfaceVariant, fontSize: 16),
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
}