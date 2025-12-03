import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:typed_data';

class QuestaoCard extends StatelessWidget {
  final Map<String, dynamic> questao;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const QuestaoCard({
    super.key,
    required this.questao,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final temImagem = questao['imagem'] != null &&
        (questao['imagem'] as String).isNotEmpty;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (temImagem)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Image.memory(
                  Uint8List.fromList(List<int>.from(questao['imagem'])),
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            Text(
              questao['titulo'] ?? 'Sem título',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Dificuldade: ${questao['idDificuldade']}',
                style: TextStyle(color: color.onSurfaceVariant)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (questao['alternativas'] as List)
                  .map((a) => Chip(
                        label: Text(a['texto']),
                        backgroundColor:
                            a['afirmativa'] == 1 ? Colors.green[200] : Colors.grey[300],
                      ))
                  .toList(),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Editar',
                  icon: const Icon(LucideIcons.edit2),
                  color: color.primary,
                  onPressed: onEdit,
                ),
                IconButton(
                  tooltip: 'Excluir',
                  icon: const Icon(LucideIcons.trash2),
                  color: Colors.redAccent,
                  onPressed: onDelete,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}