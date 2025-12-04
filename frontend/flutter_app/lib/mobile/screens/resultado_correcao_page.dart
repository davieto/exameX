import 'package:flutter/material.dart';

class ResultadoCorrecaoPage extends StatelessWidget {
  final Map<String, dynamic> resultado;

  const ResultadoCorrecaoPage({super.key, required this.resultado});

  @override
  Widget build(BuildContext context) {
    final respostas = List<String>.from(resultado['respostas']);
    final gabarito = List<String>.from(resultado['gabarito']);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resultado da Correção"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("Prova ${resultado['idProva']}",
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text("Nota: ${resultado['nota']}  |  "
               "Acertos: ${resultado['acertos']}/${resultado['totalQuestoes']}"),
          const SizedBox(height: 16),
          const Divider(),
          ...List.generate(gabarito.length, (i) {
            final resp = respostas.length > i ? respostas[i] : "-";
            final correta = gabarito[i];
            final acertou = resp == correta;

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: acertou ? Colors.green : Colors.red,
                child: Text("${i + 1}",
                    style: const TextStyle(color: Colors.white)),
              ),
              title: Text("Questão ${i + 1}"),
              subtitle: Text("Marcada: $resp   |   Correta: $correta"),
              trailing: Icon(
                acertou ? Icons.check_circle : Icons.cancel,
                color: acertou ? Colors.green : Colors.red,
              ),
            );
          }),
        ],
      ),
    );
  }
}