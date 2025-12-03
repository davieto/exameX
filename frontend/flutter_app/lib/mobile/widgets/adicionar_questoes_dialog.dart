import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'toast_message.dart';

class AdicionarQuestoesDialog extends StatefulWidget {
  final int idProva;
  const AdicionarQuestoesDialog({super.key, required this.idProva});

  @override
  State<AdicionarQuestoesDialog> createState() => _AdicionarQuestoesDialogState();
}

class _AdicionarQuestoesDialogState extends State<AdicionarQuestoesDialog> {
  bool carregando = true;
  List<dynamic> questoes = [];
  final List<int> selecionadas = [];

  @override
  void initState() {
    super.initState();
    _carregarQuestoes();
  }

  Future<void> _carregarQuestoes() async {
    try {
      final lista = await ApiService.listarQuestoes();
      setState(() {
        questoes = lista;
        carregando = false;
      });
    } catch (e) {
      ToastMessage.show(context, message: 'Erro ao carregar questões', success: false);
      Navigator.pop(context);
    }
  }

  Future<void> _salvar() async {
    if (selecionadas.isEmpty) {
      ToastMessage.show(context, message: 'Selecione pelo menos uma questão', success: false);
      return;
    }
    try {
      await ApiService.adicionarQuestoesProva(widget.idProva, selecionadas);
      ToastMessage.show(context, message: 'Questões adicionadas à prova');
      Navigator.pop(context, true);
    } catch (e) {
      ToastMessage.show(context, message: 'Erro ao adicionar questões', success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Questões'),
      content: carregando
          ? const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()))
          : SizedBox(
              width: double.maxFinite,
              height: 400,
              child: ListView.builder(
                itemCount: questoes.length,
                itemBuilder: (_, i) {
                  final q = questoes[i];
                  final id = q['idQuestaoObjetiva'];
                  final selecionada = selecionadas.contains(id);
                  return CheckboxListTile(
                    title: Text(q['titulo'] ?? 'Sem título'),
                    subtitle: Text('ID: $id  |  Dificuldade: ${q['idDificuldade']}'),
                    value: selecionada,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          selecionadas.add(id);
                        } else {
                          selecionadas.remove(id);
                        }
                      });
                    },
                  );
                },
              ),
            ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
      ],
    );
  }
}