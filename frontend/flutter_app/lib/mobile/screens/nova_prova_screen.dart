import 'package:flutter/material.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/mobile_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_button.dart';

class NovaProvaScreen extends StatelessWidget {
  const NovaProvaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _NovaProvaMobile(),
      desktop: const Scaffold(
        body: Center(child: Text('Versão desktop em construção')),
      ),
    );
  }
}

class _NovaProvaMobile extends StatefulWidget {
  @override
  State<_NovaProvaMobile> createState() => _NovaProvaMobileState();
}

class _NovaProvaMobileState extends State<_NovaProvaMobile> {
  final TextEditingController cursoCtrl = TextEditingController();
  final TextEditingController disciplinaCtrl = TextEditingController();
  final TextEditingController professorCtrl = TextEditingController();
  final TextEditingController turmaCtrl = TextEditingController();
  final TextEditingController dataCtrl = TextEditingController();
  final TextEditingController instrucoesCtrl = TextEditingController();
  int totalQuestoes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const MobileHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      CustomTextField(hintText: "Nome da Universidade"),
                      CustomTextField(hintText: "Curso", controller: cursoCtrl),
                      CustomTextField(hintText: "Disciplina", controller: disciplinaCtrl),
                      CustomTextField(hintText: "Professor", controller: professorCtrl),
                      CustomTextField(hintText: "Turma", controller: turmaCtrl),
                      CustomTextField(hintText: "Data (dd/mm/aaaa)", controller: dataCtrl),
                      CustomTextField(
                        hintText: "Instruções da prova",
                        controller: instrucoesCtrl,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 20),
                      _totalQuestoesSection(context),
                      const SizedBox(height: 20),
                      GradientButton(
                        icon: const Icon(Icons.add),
                        label: "Adicionar Questão",
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _totalQuestoesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text("Total de Questões:",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: () {
              setState(() {
                if (totalQuestoes > 0) totalQuestoes--;
              });
            },
          ),
          Text('$totalQuestoes', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.green),
            onPressed: () => setState(() => totalQuestoes++),
          ),
        ],
      ),
    );
  }
}