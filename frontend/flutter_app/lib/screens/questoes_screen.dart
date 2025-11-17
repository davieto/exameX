import 'package:flutter/material.dart';
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
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}