import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/mobile_header.dart';
import '../widgets/gradient_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _HomeMobile(),
      desktop: const Scaffold(
        body: Center(child: Text('Versão desktop em construção')),
      ),
    );
  }
}

class _HomeMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final buttons = [
      {"icon": LucideIcons.fileText, "label": "PREPARE PROVAS", "route": "/prepare-provas"},
      {"icon": LucideIcons.list, "label": "GABARITO", "route": "/gabarito"},
      {"icon": LucideIcons.search, "label": "REVISE QUESTÕES", "route": "/questoes"},
      {"icon": LucideIcons.share2, "label": "COMPARTILHE", "route": "/compartilhe"},
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const MobileHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: buttons.length,
                  itemBuilder: (context, index) {
                    final item = buttons[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GradientButton(
                        icon: Icon(item["icon"] as IconData, color: Colors.white),
                        label: item["label"] as String,
                        onPressed: () => Navigator.pushNamed(context, item["route"] as String),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}