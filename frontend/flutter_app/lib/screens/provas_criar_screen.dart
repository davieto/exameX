import 'package:flutter/material.dart';

class ProvasCriarScreen extends StatelessWidget {
  const ProvasCriarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Prova')),
      body: const Center(
        child: Text('Tela de criação de provas'),
      ),
    );
  }
}