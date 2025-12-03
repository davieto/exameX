import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/api_service.dart';
import '../widgets/ui/app_button.dart';
import '../widgets/ui/app_card.dart';
import '../widgets/ui/app_input.dart';
import '../../mobile/widgets/questao_form_dialog.dart';

class AdicionarQuestoesDialog extends StatefulWidget {
  final int idProva;
  final VoidCallback onSaved;

  const AdicionarQuestoesDialog({
    super.key,
    required this.idProva,
    required this.onSaved,
  });

  @override
  State<AdicionarQuestoesDialog> createState() =>
      _AdicionarQuestoesDialogState();
}

class _AdicionarQuestoesDialogState extends State<AdicionarQuestoesDialog> {
  List<dynamic> questoes = [];
  final List<int> selecionadas = [];
  bool carregando = true;

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
      debugPrint('Erro ao carregar questões: $e');
      setState(() => carregando = false);
    }
  }

  Future<void> salvar() async {
    if (selecionadas.isEmpty) return;
    try {
      await ApiService.adicionarQuestoesProva(widget.idProva, selecionadas);
      widget.onSaved();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Questões adicionadas à avaliação!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  void _abrirNovaQuestao() {
    showDialog(
      context: context,
      builder: (_) => QuestaoFormDialog(
        questao: null,
        onRefresh: carregarQuestoes,
        idProfessor: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Adicionar Questões à Avaliação'),
      content: SizedBox(
        width: 600,
        height: 500,
        child: carregando
            ? const Center(child: CircularProgressIndicator())
            : questoes.isEmpty
                ? const Center(child: Text('Nenhuma questão cadastrada'))
                : Column(
                    children: [
                      AppInput(
                        placeholder: 'Pesquisar questão...',
                        prefixIcon: LucideIcons.search,
                        onChanged: (valor) {
                          // filtro local
                          setState(() {
                            questoes = questoes
                                .where((q) => q['titulo']
                                    .toString()
                                    .toLowerCase()
                                    .contains(valor.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: questoes.length,
                          itemBuilder: (_, i) {
                            final q = questoes[i];
                            final id = q['idQuestaoObjetiva'];
                            final marcado = selecionadas.contains(id);
                            return AppCard(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: CheckboxListTile(
                                value: marcado,
                                title: Text(q['titulo'] ?? 'Sem título'),
                                subtitle: Text("ID: $id • Dificuldade ${q['idDificuldade']}"),
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      selecionadas.add(id);
                                    } else {
                                      selecionadas.remove(id);
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
      ),
      actions: [
        TextButton(
          onPressed: _abrirNovaQuestao,
          child: Row(
            children: [
              Icon(LucideIcons.plus, color: color.primary),
              const SizedBox(width: 6),
              Text('Nova Questão', style: TextStyle(color: color.primary)),
            ],
          ),
        ),
        const Spacer(),
        AppButton(label: 'Cancelar', variant: ButtonVariant.outline, onPressed: () => Navigator.pop(context)),
        AppButton(label: 'Salvar', onPressed: salvar),
      ],
    );
  }
}