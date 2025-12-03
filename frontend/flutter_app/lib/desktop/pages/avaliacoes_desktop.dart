<<<<<<< HEAD
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/api_service.dart';
import '../layout/desktop_layout.dart';
import '../widgets/ui/app_button.dart';
import '../widgets/ui/app_card.dart';
import '../widgets/ui/app_dialog.dart';
import '../widgets/nova_questao_dialog.dart';
import '../../mobile/widgets/questao_form_dialog.dart';

=======
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../layout/desktop_layout.dart';
import '../widgets/ui/app_button.dart';
import '../widgets/ui/app_input.dart';
import '../widgets/ui/app_card.dart';
import '../../services/api_service.dart';
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c

class AvaliacoesDesktopPage extends StatefulWidget {
  const AvaliacoesDesktopPage({super.key});

  @override
  State<AvaliacoesDesktopPage> createState() => _AvaliacoesDesktopPageState();
}

class _AvaliacoesDesktopPageState extends State<AvaliacoesDesktopPage> {
  List<dynamic> provas = [];
  bool carregando = true;
<<<<<<< HEAD
=======
  final _buscarController = TextEditingController();
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c

  @override
  void initState() {
    super.initState();
    carregarProvas();
  }

  Future<void> carregarProvas() async {
<<<<<<< HEAD
    setState(() => carregando = true);
=======
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
    try {
      final lista = await ApiService.listarProvas();
      setState(() {
        provas = lista;
<<<<<<< HEAD
      });
    } finally {
=======
        carregando = false;
      });
    } catch (e) {
      debugPrint('Erro ao carregar provas: $e');
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
      setState(() => carregando = false);
    }
  }

<<<<<<< HEAD
  /// === Criar nova avaliação (com seleção de questões e formulário completo) ===
  void _abrirFormularioNovaProva() async {
    final tituloCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    List<int> selecionadas = [];
    List<dynamic> todasQuestoes = [];
    List<dynamic> questoesFiltradas = [];
    bool carregando = true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(builder: (context, setModalState) {
        Future<void> carregarQuestoes() async {
          setModalState(() => carregando = true);
          final lista = await ApiService.listarQuestoes();
          setModalState(() {
            todasQuestoes = lista;
            questoesFiltradas = lista;
            carregando = false;
          });
        }

      // Carrega apenas uma vez
        if (carregando) {
          carregarQuestoes();
        }

        Future<void> abrirNovaQuestaoCompleta() async {
  await showDialog(
    context: context,
    builder: (_) => NovaQuestaoDialog(
      open: true,
      onOpenChange: (open) async {
        if (!open) {
          Navigator.pop(context);
          // Atualiza a lista de questões após criar nova
          final lista = await ApiService.listarQuestoes();
          setModalState(() {
            todasQuestoes = lista;
            questoesFiltradas = lista;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Nova questão criada com sucesso!")),
          );
        }
      },
    ),
  );
}

        return AlertDialog(
          title: const Text('Nova Avaliação'),
          content: SizedBox(
            width: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: tituloCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Título da prova'),
                ),
                TextField(
                  controller: descCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Descrição da prova'),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Selecione as questões"),
                    TextButton.icon(
                      onPressed: abrirNovaQuestaoCompleta,
                      icon: const Icon(Icons.add),
                      label: const Text("Nova Questão"),
                    ),
                  ],
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Pesquisar questão...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (valor) {
                    setModalState(() {
                      questoesFiltradas = todasQuestoes
                          .where((q) => q['titulo']
                              .toString()
                              .toLowerCase()
                              .contains(valor.toLowerCase()))
                          .toList();
                    });
                  },
                ),
                const SizedBox(height: 10),
                if (carregando)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      itemCount: questoesFiltradas.length,
                      itemBuilder: (_, i) {
                        final q = questoesFiltradas[i];
                        final marcado =
                            selecionadas.contains(q['idQuestaoObjetiva']);
                        return CheckboxListTile(
                          value: marcado,
                          title: Text(q['titulo']),
                          onChanged: (v) {
                            setModalState(() {
                              if (v == true) {
                                selecionadas.add(q['idQuestaoObjetiva']);
                              } else {
                                selecionadas.remove(q['idQuestaoObjetiva']);
                              }
                            });
                          },
=======
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
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
<<<<<<< HEAD
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final dados = {
                  'titulo': tituloCtrl.text,
                  'descricao': descCtrl.text,
                };
                final provaId = await ApiService.criarProvaComRetorno(dados);
                if (selecionadas.isNotEmpty) {
                  await ApiService.adicionarQuestoesProva(provaId, selecionadas);
                }
                await carregarProvas();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      }),
    );
  }

/// === Visualizar, reordenar, remover e adicionar novas questões ===
void _verQuestoes(int idProva) async {
  List<dynamic> questoesLocais = await ApiService.listarQuestoesDaProva(idProva);

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(builder: (ctx, setState) {
      Future<void> recarregar() async {
        final novas = await ApiService.listarQuestoesDaProva(idProva);
        setState(() => questoesLocais = List.of(novas));
      }

      // === Criar questão nova completa e adicionar à prova ===
Future<void> criarNovaQuestaoEAdicionar() async {
  await showDialog(
    context: context,
    builder: (_) => NovaQuestaoDialog(
      open: true,
      onOpenChange: (open) async {
        if (!open) {
          Navigator.pop(context);
          // pega a última questão criada e adiciona à prova
          final todas = await ApiService.listarQuestoes();
          if (todas.isNotEmpty) {
            final nova = todas.last;
            await ApiService.adicionarQuestoesProva(
                idProva, [nova['idQuestaoObjetiva']]);
            await recarregar();
          }
        }
      },
    ),
  );
}

      // === Adicionar questão existente à prova ===
      Future<void> adicionarQuestaoExistente() async {
        final todasQuestoes = await ApiService.listarQuestoes();
        final selecionadas = <int>[];

        await showDialog(
          context: context,
          builder: (_) => StatefulBuilder(builder: (ctx2, setModal) {
            var filtradas = todasQuestoes;
            return AlertDialog(
              title: const Text("Adicionar Questões Existentes"),
              content: SizedBox(
                width: 500,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Pesquisar questão por título...",
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (valor) {
                        setModal(() {
                          filtradas = todasQuestoes
                              .where((q) => q['titulo']
                                  .toString()
                                  .toLowerCase()
                                  .contains(valor.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtradas.length,
                        itemBuilder: (_, i) {
                          final q = filtradas[i];
                          final marcado = selecionadas.contains(q['idQuestaoObjetiva']);
                          return CheckboxListTile(
                            value: marcado,
                            title: Text(q['titulo']),
                            onChanged: (v) {
                              setModal(() {
                                if (v == true) {
                                  selecionadas.add(q['idQuestaoObjetiva']);
                                } else {
                                  selecionadas.remove(q['idQuestaoObjetiva']);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx2),
                    child: const Text("Cancelar")),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(ctx2);
                      if (selecionadas.isNotEmpty) {
                        await ApiService.adicionarQuestoesProva(
                            idProva, selecionadas);
                        await recarregar();
                      }
                    },
                    child: const Text("Adicionar")),
              ],
            );
          }),
        );
      }

      // === Diálogo principal ===
      return AlertDialog(
        title: Row(
          children: [
            const Expanded(child: Text('Questões da Avaliação')),
            TextButton.icon(
              onPressed: criarNovaQuestaoEAdicionar,
              icon: const Icon(Icons.add),
              label: const Text("Nova Questão"),
            ),
            const SizedBox(width: 10),
            TextButton.icon(
              onPressed: adicionarQuestaoExistente,
              icon: const Icon(Icons.search),
              label: const Text("Procurar"),
            ),
          ],
        ),
        content: SizedBox(
          width: 700,
          height: 440,
          child: questoesLocais.isEmpty
              ? const Center(child: Text("Nenhuma questão vinculada"))
              : ReorderableListView(
                  onReorder: (oldIndex, newIndex) async {
                    setState(() {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final item = questoesLocais.removeAt(oldIndex);
                      questoesLocais.insert(newIndex, item);
                    });
                    final novaOrdem = questoesLocais
                        .map<int>((q) => q['idQuestaoObjetiva'] as int)
                        .toList();
                    await ApiService.atualizarOrdemQuestoes(idProva, novaOrdem);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Ordem atualizada")),
                    );
                  },
                  children: [
                    for (int i = 0; i < questoesLocais.length; i++)
                      Card(
                        key: ValueKey(questoesLocais[i]['idQuestaoObjetiva']),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${i + 1}. ${questoesLocais[i]['titulo']}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: "Remover questão da prova",
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () async {
                                      await ApiService.removerQuestaoProva(
                                        idProva,
                                        questoesLocais[i]['idQuestaoObjetiva'],
                                      );
                                      await recarregar();
                                    },
                                  ),
                                ],
                              ),
                              for (final alt in questoesLocais[i]['alternativas'])
                                Padding(
                                  padding: const EdgeInsets.only(left: 14),
                                  child: Text(
                                    '• ${alt['texto']}',
                                    style: TextStyle(
                                      color: alt['afirmativa'] == 1
                                          ? Colors.green.shade800
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      );
    }),
  );
}

  /// === Excluir prova ===
  void _excluirProva(int id) async {
    AppDialog.show(
      context,
      title: 'Excluir prova?',
      description: 'Esta ação não pode ser desfeita.',
      confirmText: 'Excluir',
      cancelText: 'Cancelar',
      onConfirm: () async {
        await ApiService.deletarProva(id);
        await carregarProvas();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return DesktopLayout(
      content: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Avaliações',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color.onSurface,
                      )),
              AppButton(
                label: 'Nova Avaliação',
                icon: LucideIcons.plus,
                onPressed: _abrirFormularioNovaProva,
              ),
            ]),
            const SizedBox(height: 24),
            if (carregando)
              const Center(child: CircularProgressIndicator())
            else if (provas.isEmpty)
              Center(
                child: Text('Nenhuma prova encontrada',
                    style: TextStyle(color: color.onSurfaceVariant)),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: provas.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final prova = provas[i];
                    return AppCard(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(prova['titulo'] ?? 'Sem título',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: color.onSurface)),
                                if (prova['descricao'] != null)
                                  Text(prova['descricao'],
                                      style: TextStyle(
                                          color: color.onSurfaceVariant)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                tooltip: 'Visualizar questões',
                                icon: const Icon(LucideIcons.eye),
                                onPressed: () => _verQuestoes(prova['idProva']),
                              ),
                              IconButton(
                                tooltip: 'Excluir',
                                icon: const Icon(LucideIcons.trash2),
                                onPressed: () =>
                                    _excluirProva(prova['idProva']),
                              ),
                              AppButton(
                                label: 'PDF',
                                variant: ButtonVariant.outline,
                                icon: LucideIcons.fileText,
                                onPressed: () async {
                                  final bytes = await ApiService.gerarPdf(
                                      prova['idProva']);
                                  await FileSaver.instance.saveFile(
                                    name: 'prova_${prova['idProva']}',
                                    bytes: bytes,
                                    ext: 'pdf',
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('PDF gerado com sucesso')));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
=======
        ),
      );
    });
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
  }
}