import 'package:flutter/material.dart';
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
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}