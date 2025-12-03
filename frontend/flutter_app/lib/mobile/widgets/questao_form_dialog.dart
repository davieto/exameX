import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';
import 'package:examex/mobile/widgets/toast_message.dart';

class QuestaoFormDialog extends StatefulWidget {
  final Map<String, dynamic>? questao; // se vier, é edição
  final VoidCallback onRefresh;
  final int idProfessor;
  const QuestaoFormDialog({super.key, this.questao, required this.onRefresh, required this.idProfessor});

  @override
  State<QuestaoFormDialog> createState() => _QuestaoFormDialogState();
}

class _QuestaoFormDialogState extends State<QuestaoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  int _idDificuldade = 1;
  List<Map<String, dynamic>> _alternativas = [];
  int _respostaCorreta = 0;
  File? _imagem;

  @override
  void initState() {
    super.initState();
    if (widget.questao != null) {
      _tituloCtrl.text = widget.questao!['titulo'] ?? '';
      _idDificuldade = (widget.questao!['idDificuldade'] ?? 1) as int;
      _alternativas = List<Map<String, dynamic>>.from(widget.questao!['alternativas'] ?? []);
      // garantir que tenha 5 alternativas
      if (_alternativas.length < 5) {
        for (int i = _alternativas.length; i < 5; i++) {
          _alternativas.add({'texto': '', 'afirmativa': 0});
        }
      }
      _respostaCorreta = _alternativas.indexWhere((a) => a['afirmativa'] == 1);
      if (_respostaCorreta < 0) _respostaCorreta = 0;
    } else {
      _alternativas = List.generate(
        5,
        (i) => {'texto': '', 'afirmativa': i == 0 ? 1 : 0},
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imagem = File(picked.path));
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_alternativas.any((a) => a['texto'].trim().isEmpty)) {
      ToastMessage.show(context, message: 'Preencha todas as alternativas', success: false);
      return;
    }

    final imagePath = _imagem?.path;

    // definir a alternativa correta
    for (int i = 0; i < _alternativas.length; i++) {
      _alternativas[i]['afirmativa'] = i == _respostaCorreta ? 1 : 0;
    }

    final dados = {
      'titulo': _tituloCtrl.text.trim(),
      'idDificuldade': _idDificuldade,
      'idProfessor': widget.idProfessor,
      'alternativas': _alternativas,
      if (imagePath != null) 'imagem': imagePath,
    };

    try {
      await ApiService.criarQuestaoObjetiva(dados);
      ToastMessage.show(context, message: 'Questão salva com sucesso');
      widget.onRefresh();
      Navigator.pop(context);
    } catch (e) {
      ToastMessage.show(context, message: 'Erro ao salvar: $e', success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(widget.questao == null ? 'Nova Questão' : 'Editar Questão'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloCtrl,
                decoration: const InputDecoration(labelText: "Título da Questão"),
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _idDificuldade,
                decoration: const InputDecoration(labelText: "Dificuldade"),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Fácil')),
                  DropdownMenuItem(value: 2, child: Text('Média')),
                  DropdownMenuItem(value: 3, child: Text('Difícil')),
                ],
                onChanged: (v) => setState(() => _idDificuldade = v ?? 1),
              ),
              const SizedBox(height: 12),
              const Text("Alternativas", style: TextStyle(fontWeight: FontWeight.bold)),
              for (int i = 0; i < _alternativas.length; i++)
                ListTile(
                  title: TextFormField(
                    initialValue: _alternativas[i]['texto'],
                    decoration: InputDecoration(
                      labelText: 'Alternativa ${String.fromCharCode(65 + i)}',
                    ),
                    onChanged: (v) => _alternativas[i]['texto'] = v,
                  ),
                  leading: Radio<int>(
                    value: i,
                    groupValue: _respostaCorreta,
                    onChanged: (v) => setState(() => _respostaCorreta = v!),
                  ),
                ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Selecionar Imagem (opcional)"),
              ),
              if (_imagem != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Image.file(_imagem!, height: 100),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(onPressed: _salvar, child: const Text("Salvar")),
      ],
    );
  }
}