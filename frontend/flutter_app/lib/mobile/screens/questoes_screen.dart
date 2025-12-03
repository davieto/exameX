import 'package:flutter/material.dart';
<<<<<<< HEAD
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

=======
import '../widgets/responsive_layout.dart';
import '../widgets/mobile_header.dart';
import '../widgets/search_filters.dart';
import '../widgets/empty_state.dart';
import '../widgets/bottom_nav_bar.dart';

class QuestoesScreen extends StatelessWidget {
  const QuestoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _QuestoesMobile(),
      desktop: const Scaffold(
        body: Center(child: Text('Versão desktop em construção')),
      ),
    );
  }
}

class _QuestoesMobile extends StatelessWidget {
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
<<<<<<< HEAD
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
=======
        child: Column(
          children: [
            const MobileHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  Text(
                    "Pesquise ou cadastre questões",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 16),
                  SearchFilters(),
                  SizedBox(height: 16),
                  EmptyState(),
                ],
              ),
            ),
          ],
        ),
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}