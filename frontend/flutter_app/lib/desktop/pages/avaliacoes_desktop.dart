import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/api_service.dart';
import '../layout/desktop_layout.dart';
import '../widgets/ui/app_button.dart';
import '../widgets/ui/app_card.dart';
import '../widgets/ui/app_input.dart';
import '../widgets/ui/app_dialog.dart';
import 'questoes_desktop.dart';
import '../widgets/adicionar_questoes_dialog.dart';

class AvaliacoesDesktopPage extends StatefulWidget {
  const AvaliacoesDesktopPage({super.key});

  @override
  State<AvaliacoesDesktopPage> createState() => _AvaliacoesDesktopPageState();
}

class _AvaliacoesDesktopPageState extends State<AvaliacoesDesktopPage> {
  List<dynamic> provas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarProvas();
  }

  Future<void> carregarProvas() async {
    try {
      setState(() => carregando = true);
      final lista = await ApiService.listarProvas();
      setState(() {
        provas = lista;
        carregando = false;
      });
    } catch (e) {
      debugPrint('Erro ao listar provas: $e');
      setState(() => carregando = false);
    }
  }

  /// === Criação com formulário ===
  void _abrirFormularioNovaProva() {
    final tituloCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Criar nova avaliação'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloCtrl,
              decoration: const InputDecoration(labelText: 'Título da prova'),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (tituloCtrl.text.trim().isEmpty) return;
              Navigator.pop(context);
              await ApiService.criarProva(
                tituloCtrl.text.trim(),
                descCtrl.text.trim(),
              );
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Avaliação criada!')));
              await carregarProvas();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  /// === Edição título/descrição ===
  void _editarProva(Map prova) {
    final tituloCtrl = TextEditingController(text: prova['titulo']);
    final descCtrl = TextEditingController(text: prova['descricao'] ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar avaliação'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloCtrl,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ApiService.atualizarProva(
                prova['idProva'],
                {
                  'titulo': tituloCtrl.text.trim(),
                  'descricao': descCtrl.text.trim(),
                },
              );
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Prova atualizada!')));
              await carregarProvas();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  /// === Exclusão ===
  void _excluirProva(int id) {
    AppDialog.show(
      context,
      title: 'Excluir prova?',
      description: 'Esta ação não pode ser desfeita.',
      confirmText: 'Excluir',
      cancelText: 'Cancelar',
      onConfirm: () async {
        await ApiService.deletarProva(id);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Prova excluída!")));
        await carregarProvas();
      },
    );
  }

  /// === Visualização (lista de questões) ===
  void _verQuestoes(int idProva) async {
    final questoes = await ApiService.listarQuestoesDaProva(idProva);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Questões da Avaliação'),
        content: SizedBox(
          width: 500,
          child: questoes.isEmpty
              ? const Text("Nenhuma questão vinculada.")
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: questoes
                      .map((q) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text('•  ${q['titulo']}'),
                          ))
                      .toList(),
                ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
        ],
      ),
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
            carregando
                ? const Center(child: CircularProgressIndicator())
                : provas.isEmpty
                    ? Center(
                        child: Text('Nenhuma prova encontrada',
                            style: TextStyle(color: color.onSurfaceVariant)),
                      )
                    : Expanded(
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
                                                  color: color.onSurfaceVariant))
                                      ],
                                    ),
                                  ),
                                  Row(children: [
                                    IconButton(
                                      tooltip: 'Visualizar questões',
                                      icon: const Icon(LucideIcons.eye),
                                      onPressed: () => _verQuestoes(prova['idProva']),
                                    ),
                                    IconButton(
                                      tooltip: 'Editar',
                                      icon: const Icon(LucideIcons.edit2),
                                      onPressed: () => _editarProva(prova),
                                    ),
                                    IconButton(
                                      tooltip: 'Excluir',
                                      icon: const Icon(LucideIcons.trash2),
                                      onPressed: () => _excluirProva(prova['idProva']),
                                    ),
                                    IconButton(
  tooltip: 'Gerenciar Questões',
  icon: const Icon(LucideIcons.listPlus),
  onPressed: () {
    showDialog(
      context: context,
      builder: (_) => AdicionarQuestoesDialog(
        idProva: prova['idProva'],
        onSaved: carregarProvas,
      ),
    );
  },
),
const SizedBox(width: 12),
AppButton(
  label: 'PDF',
  variant: ButtonVariant.outline,
  icon: LucideIcons.fileText,
  onPressed: () async {
    final bytes = await ApiService.gerarPdf(prova['idProva']);
    await FileSaver.instance.saveFile(
      name: 'prova_${prova['idProva']}',
      bytes: bytes,
      ext: 'pdf',
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('PDF gerado!')));
  },
),
                                    const SizedBox(width: 12),
                                    AppButton(
                                      label: 'PDF',
                                      variant: ButtonVariant.outline,
                                      icon: LucideIcons.fileText,
                                      onPressed: () async {
                                        final bytes = await ApiService.gerarPdf(prova['idProva']);
                                        await FileSaver.instance.saveFile(
  name: 'prova_${prova['idProva']}',
  bytes: bytes,
  ext: 'pdf',
);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('PDF gerado!')));
                                      },
                                    ),
                                  ])
                                ],
                              ),
                            );
                          },
                        ),
                      )
          ],
        ),
      ),
    );
  }
}