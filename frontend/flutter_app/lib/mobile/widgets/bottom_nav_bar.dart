import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';
import '../screens/stream_omr_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, this.currentIndex = 2});

  Future<void> _abrirCameraCorrigir(BuildContext context) async {
    final picker = ImagePicker();
    final foto = await picker.pickImage(source: ImageSource.camera);

    if (foto == null) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enviando para correção...")));

      final resultado = await ApiService.corrigirGabarito(foto);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Correção concluída"),
          content: Text(
            "Prova: ${resultado['idProva']}\n"
            "Acertos: ${resultado['acertos']}/${resultado['totalQuestoes']}\n"
            "Nota: ${resultado['nota']}",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fechar"),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        "icon": LucideIcons.fileText,
        "label": "Provas",
        "route": "/prepare-provas"
      },
      {"icon": LucideIcons.list, "label": "Gabarito", "route": "/gabarito"},
      {"icon": LucideIcons.camera, "label": "Corrigir", "action": "scan"},
      {"icon": LucideIcons.search, "label": "Questões", "route": "/questoes"},
      {
        "icon": LucideIcons.share2,
        "label": "Compartilhe",
        "route": "/compartilhe"
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10)
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            return GestureDetector(
              onTap: () {
                if (item["action"] == "scan") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StreamOMRPage()),
                  );
                } else {
                  Navigator.pushNamed(context, item["route"] as String);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item["icon"] as IconData,
                    color: idx == currentIndex ? Colors.white : Colors.white70,
                  ),
                  Text(
                    item["label"] as String,
                    style: TextStyle(
                      color:
                          idx == currentIndex ? Colors.white : Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
