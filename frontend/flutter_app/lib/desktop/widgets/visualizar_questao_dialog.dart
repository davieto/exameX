import 'package:flutter/material.dart';

class VisualizarQuestaoDialog extends StatelessWidget {
  final dynamic questao;

  const VisualizarQuestaoDialog({super.key, required this.questao});

  String _rotuloDificuldade(dynamic valor) {
    if (valor == 1) return "Fácil";
    if (valor == 2) return "Médio";
    if (valor == 3) return "Difícil";
    return "—";
  }

  @override
  @override
Widget build(BuildContext context) {
  final color = Theme.of(context).colorScheme;

  return AlertDialog(
    backgroundColor: color.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    content: Container(
      width: 700,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === 🟡 ASSUNTOS NO TOPO COM DESTAQUE ===
            if (questao['assuntos'] != null &&
                (questao['assuntos'] as List).isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: (questao['assuntos'] as List)
                      .map(
                        (a) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: color.primary, width: 1.2),
                            borderRadius: BorderRadius.circular(50),
                            color:
                                color.primary.withOpacity(0.08), // leve fundo
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          child: Text(
                            a['nome']?.toString() ?? '',
                            style: TextStyle(
                              color: color.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

            // === TÍTULO ===
            Text('Visualizar Questão',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: color.primary,
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 16),

            _info('Título', questao['titulo'] ?? '—'),
            _info('Descrição / Contexto', questao['descricao'] ?? '—'),
            _info(
              'Enunciado da Questão (Texto)',
              questao['texto']?.toString().trim().isNotEmpty == true
                  ? questao['texto']
                  : '—',
            ),
            _info('Tipo', questao['tipo'] ?? 'Objetiva'),
            _info('Acesso', questao['acesso'] ?? '—'),
            _info('Dificuldade', _rotuloDificuldade(questao['idDificuldade'])),
            _info('Professor ID', '${questao['idProfessor'] ?? "—"}'),
            const SizedBox(height: 12),

            // === ALTERNATIVAS ===
            if (questao['alternativas'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Alternativas:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.onSurface)),
                  const SizedBox(height: 4),
                  for (final alt in questao['alternativas'])
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '• ${alt['texto'] ?? ""}',
                              style: TextStyle(
                                color: color.onSurfaceVariant,
                                fontWeight: alt['afirmativa'] == 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (alt['afirmativa'] == 1)
                            const Icon(Icons.check_circle,
                                color: Colors.green, size: 18),
                        ],
                      ),
                    ),
                ],
              ),

            const SizedBox(height: 16),

            // === IMAGEM ===
            if (questao['imagem'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Imagem:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.onSurface)),
                  const SizedBox(height: 6),
                  Image.memory(
                    questao['imagem'],
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

            const Divider(height: 32),

            // === CURSO E DISCIPLINA (agora devem estar preenchidos) ===
            _info('Curso', questao['curso']?['nome'] ?? '—'),
            _info('Disciplina', questao['materia']?['nome'] ?? '—'),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Fechar', style: TextStyle(color: color.primary)),
      ),
    ],
  );
}

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 130,
              child: Text("$label:",
                  style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value, maxLines: 5, overflow: TextOverflow.fade))
        ],
      ),
    );
  }
}