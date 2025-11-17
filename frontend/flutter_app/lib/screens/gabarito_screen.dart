import 'package:flutter/material.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/mobile_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/gradient_button.dart';

class GabaritoScreen extends StatelessWidget {
  const GabaritoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _GabaritoMobile(),
      desktop: const Scaffold(
        body: Center(child: Text('Versão desktop em construção')),
      ),
    );
  }
}

class _GabaritoMobile extends StatefulWidget {
  @override
  State<_GabaritoMobile> createState() => _GabaritoMobileState();
}

class _GabaritoMobileState extends State<_GabaritoMobile> {
  final List<String> senha = List.filled(4, '');
  final List<String> senhaConfirm = List.filled(4, '');
  final List<Map<String, dynamic>> questoes = [
    {'id': 1, 'valor': 1.0, 'tipo': 'DISCURSIVA', 'resposta': ''},
    {'id': 2, 'valor': 0.5, 'tipo': 'MULTIPLA', 'resposta': 'D'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const MobileHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF9B1C3F), Color(0xFFB23359)]),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "CRIAR GABARITO",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 16),
          _buildSenhaRow("SENHA PARA CORREÇÃO", senha),
          const SizedBox(height: 16),
          _buildSenhaRow("CONFIRME A SENHA", senhaConfirm),
          const SizedBox(height: 16),
          const Divider(color: Colors.white70),
                   const SizedBox(height: 12),
          _tableQuestoes(),
          const SizedBox(height: 20),
          GradientButton(
            icon: const Icon(Icons.picture_as_pdf),
            label: "GERAR PDF",
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSenhaRow(String label, List<String> lista) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(lista.length, (i) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 50,
              child: TextField(
                textAlign: TextAlign.center,
                onChanged: (val) => setState(() => lista[i] = val),
                maxLength: 1,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                decoration: InputDecoration(
                  counterText: "",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _tableQuestoes() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: Text("VALOR",
                    style: TextStyle(color: Colors.white)),
              ),
              Expanded(
                child: Text("TIPO",
                    style: TextStyle(color: Colors.white)),
              ),
              Expanded(
                child: Text("RESPOSTA",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < questoes.length; i++)
            Row(
              children: [
                Expanded(
                    child: Text("${questoes[i]['valor']}",
                        style: const TextStyle(color: Colors.white))),
                Expanded(
                    child: Text(questoes[i]['tipo'],
                        style: const TextStyle(color: Colors.white))),
                Expanded(
                  child: Center(
                    child: questoes[i]['resposta'].isEmpty
                        ? const Text("-",
                            style: TextStyle(color: Colors.white54))
                        : CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red.shade400,
                            child: Text(
                              questoes[i]['resposta'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}