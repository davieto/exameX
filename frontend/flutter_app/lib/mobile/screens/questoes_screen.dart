import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../widgets/questao_card.dart';
import '../widgets/questao_form_dialog.dart';
import '../widgets/toast_message.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/mobile_header.dart';

class QuestoesScreen extends StatefulWidget {
  const QuestoesScreen({super.key});

  @override
  State<QuestoesScreen> createState() => _QuestoesScreenState();
}

class _QuestoesScreenState extends State<QuestoesScreen> {
  bool carregando = false;
  List<dynamic> questoes = [];

  @override
  void initState() {
    super.initState();
    carregarQuestoes();
  }

  Future<void> carregarQuestoes() async {
    setState(() => carregando = true);
    try {
      final lista = await ApiService.listarQuestoes();
      setState(() => questoes = lista);
    } catch (e) {
      ToastMessage.show(context, message: 'Erro ao carregar questões', success: false);
    } finally {
      setState(() => carregando = false);
    }
  }

  void _abrirForm([Map<String, dynamic>? questao]) {
    showDialog(
      context: context,
      builder: (_) => QuestaoFormDialog(
        questao: questao,
        idProfessor: 1, // temporário, até login completo
        onRefresh: carregarQuestoes,
      ),
    );
  }

  Future<void> _excluirQuestao(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Excluir questão?"),
        content: const Text("Essa ação não pode ser desfeita."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Excluir")),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await ApiService.deletarQuestao(id);
      ToastMessage.show(context, message: 'Questão removida');
      carregarQuestoes();
    } catch (e) {
      ToastMessage.show(context, message: 'Erro ao excluir', success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          const MobileHeader(),
          Expanded(
            child: carregando
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: carregarQuestoes,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: questoes.length,
                      itemBuilder: (_, i) {
                        final q = questoes[i];
                        return QuestaoCard(
                          questao: q,
                          onEdit: () => _abrirForm(q),
                          onDelete: () => _excluirQuestao(q['idQuestaoObjetiva']),
                        );
                      },
                    ),
                  ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _abrirForm(),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}