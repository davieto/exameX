import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'toast_message.dart';

class ProvaFormDialog extends StatefulWidget {
  final VoidCallback onRefresh;
  const ProvaFormDialog({super.key, required this.onRefresh});

  @override
  State<ProvaFormDialog> createState() => _ProvaFormDialogState();
}

class _ProvaFormDialogState extends State<ProvaFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _descricaoCtrl = TextEditingController();
  bool _salvando = false;

  Future<void> _criarProva() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    try {
      await ApiService.criarProva(_tituloCtrl.text.trim(), _descricaoCtrl.text.trim());
      ToastMessage.show(context, message: 'Prova criada com sucesso');
      widget.onRefresh();
      Navigator.pop(context);
    } catch (e) {
      ToastMessage.show(context, message: 'Erro ao criar prova: $e', success: false);
    } finally {
      setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nova Prova"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _tituloCtrl,
              decoration: const InputDecoration(labelText: "Título da prova"),
              validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descricaoCtrl,
              decoration: const InputDecoration(labelText: "Descrição (opcional)"),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _salvando ? null : () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: _salvando ? null : _criarProva,
          child: _salvando
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Salvar"),
        ),
      ],
    );
  }
}