import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'topbar.dart';

class DesktopLayout extends StatelessWidget {
  final Widget content;

  const DesktopLayout({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: Column(
              children: [
                const TopBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: content,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}