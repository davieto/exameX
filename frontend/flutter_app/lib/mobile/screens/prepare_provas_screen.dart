import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../../services/api_service.dart';
import '../widgets/mobile_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/prova_form_dialog.dart';
import '../widgets/adicionar_questoes_dialog.dart';
import '../widgets/toast_message.dart';

class PrepareProvasScreen extends StatefulWidget {
  const PrepareProvasScreen({super.key});

  @override
  State<PrepareProvasScreen> createState() => _PrepareProvasScreenState();
}

class _PrepareProvasScreenState extends State<PrepareProvasScreen> {
  bool carregando = true;
  List<dynamic> provas = [];

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
      ToastMessage.show(context, message: 'Erro ao carregar provas', success: false);
      setState(() => carregando = false);
    }
  }

  void _abrirForm() {
    showDialog(
      context: context,
      builder: (_) => ProvaFormDialog(onRefresh: carregarProvas),
    );
  }

  void _abrirAdicionarQuestoes(int idProva) {
    showDialog(
      context: context,
      builder: (_) => AdicionarQuestoesDialog(idProva: idProva),
    ).then((atualizou) {
      if (atualizou == true) carregarProvas();
    });
  }

=======
import '../widgets/responsive_layout.dart';
import '../widgets/mobile_header.dart';
import '../widgets/create_evaluation_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/bottom_nav_bar.dart';

class PrepareProvasScreen extends StatelessWidget {
  const PrepareProvasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _PrepareProvasMobile(),
      desktop: const Scaffold(
        body: Center(child: Text('Versão desktop em construção')),
      ),
    );
  }
}

class _PrepareProvasMobile extends StatelessWidget {
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
                : provas.isEmpty
                    ? const Center(child: Text("Nenhuma prova criada ainda"))
                    : RefreshIndicator(
                        onRefresh: carregarProvas,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: provas.length,
                          itemBuilder: (_, i) {
                            final p = provas[i];
                            return Card(
                              child: ListTile(
                                title: Text(p['titulo'] ?? 'Sem título'),
                                subtitle: Text(p['descricao'] ?? ''),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'questoes') {
                                      _abrirAdicionarQuestoes(p['idProva']);
                                    }
                                  },
                                  itemBuilder: (_) => [
                                    const PopupMenuItem(
                                      value: 'questoes',
                                      child: Text('Adicionar Questões'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: _abrirForm,
=======
        child: Column(
          children: [
            const MobileHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    const CreateEvaluationCard(),
                    const SizedBox(height: 16),
                    GradientButton(
                      icon: const Icon(Icons.history, color: Colors.black),
                      label: "VER AVALIAÇÕES ANTERIORES",
                      onPressed: () {},
                      darkText: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}