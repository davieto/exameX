import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/mobile_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/gradient_button.dart';

class CompartilharScreen extends StatelessWidget {
  const CompartilharScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _CompartilharMobile(),
      desktop: const Scaffold(
        body: Center(child: Text('Versão desktop em construção')),
      ),
    );
  }
}

class _CompartilharMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const MobileHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF9B1C3F), Color(0xFFB23359)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: const Icon(
                          LucideIcons.share2,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Compartilhe suas avaliações",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Envie provas e gabaritos para outros professores ou alunos facilmente.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 32),
                      GradientButton(
                        icon: const Icon(LucideIcons.users, color: Colors.black),
                        label: "COMPARTILHAR COM TURMA",
                        darkText: true,
                        onPressed: () {},
                      ),
                      const SizedBox(height: 16),
                      GradientButton(
                        icon: const Icon(LucideIcons.link, color: Colors.black),
                        label: "GERAR LINK DE COMPARTILHAMENTO",
                        darkText: true,
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
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }
}