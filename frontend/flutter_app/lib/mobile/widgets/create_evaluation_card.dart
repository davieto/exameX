import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CreateEvaluationCard extends StatelessWidget {
  const CreateEvaluationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF9B1C3F), Color(0xFFB23359)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Normas para sua prova",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _IconContainer(icon: LucideIcons.fileText),
              SizedBox(width: 16),
              _IconContainer(icon: LucideIcons.plus),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/nova-prova');
            },
            child: const Text('PROCURE OU CRIE UMA AVALIAÇÃO'),
          ),
        ],
      ),
    );
  }
}

class _IconContainer extends StatelessWidget {
  final IconData icon;
  const _IconContainer({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}