import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class NovaQuestaoDialog extends StatefulWidget {
  final bool open;
  final Function(bool) onOpenChange;

  final Map<String, dynamic>? questaoOriginal;

  const NovaQuestaoDialog({
    super.key,
    required this.open,
    required this.onOpenChange,
    this.questaoOriginal,
  });

  @override
  State<NovaQuestaoDialog> createState() => _NovaQuestaoDialogState();
}

class _NovaQuestaoDialogState extends State<NovaQuestaoDialog> {
  final List<TextEditingController> alternativaCtrls = List.generate(
    5,
    (_) => TextEditingController(),
  );
  // === Controladores de texto ===
  final tituloCtrl = TextEditingController();
  final descricaoCtrl = TextEditingController();
  final textoCtrl = TextEditingController();
  final linhasDesenhoCtrl = TextEditingController(text: "0");
  final novoAssunto = TextEditingController();

  // === variáveis de estado ===
  String tipoQuestao = 'multipla';
  String acesso = 'privada';
  String dificuldade = 'medio';
  bool hasImage = false;
  String? alternativaCorreta;
  List<String> assuntos = [];
  List<dynamic> cursos = [];
  List<dynamic> materias = [];
  int? cursoSelecionado;
  int? materiaSelecionada;

  @override
  void initState() {
    super.initState();

    // Garante que o preenchimento aconteça após a primeira renderização
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preencherCampos();
    });
  }

  Future<void> _preencherCampos() async {
    await carregarDadosDropdowns();

    if (!mounted || widget.questaoOriginal == null) return;
    final q = widget.questaoOriginal!;

    tituloCtrl.text = q['titulo']?.toString() ?? '';
    descricaoCtrl.text = q['descricao']?.toString() ?? '';
    textoCtrl.text = q['texto']?.toString() ?? '';

    tipoQuestao = q['tipo']?.toString() ?? 'multipla';
    acesso = q['acesso']?.toString() ?? 'privada';
    dificuldade = _mapDificuldade(q['idDificuldade']);

    cursoSelecionado = q['idCurso'];
    materiaSelecionada = q['idMateria'];

    linhasDesenhoCtrl.text = (q['linhas_desenho'] ?? 0).toString();

    if (q['alternativas'] != null && q['alternativas'] is List) {
      final List<dynamic> alternativas = q['alternativas'];
      for (int i = 0; i < alternativaCtrls.length; i++) {
        alternativaCtrls[i].text =
            i < alternativas.length ? (alternativas[i]['texto'] ?? '') : '';
      }

      final correta = alternativas.firstWhere(
        (a) => a['afirmativa'] == 1,
        orElse: () => <String, dynamic>{},
      );
      final idxCorreta = alternativas.indexOf(correta);
      if (idxCorreta >= 0) {
        alternativaCorreta = String.fromCharCode(97 + idxCorreta);
      }
    }

    // === Assuntos ===
    if (q['assuntos'] != null && q['assuntos'] is List) {
      assuntos = List<String>.from(
        q['assuntos']
            .map((a) => a['nome']?.toString() ?? '')
            .where((a) => a.isNotEmpty),
      );
    }

    setState(() {});
  }

  Future<void> carregarDadosDropdowns() async {
    try {
      final listaCursos = await ApiService.listarCursos();
      final listaMaterias = await ApiService.listarMaterias();
      setState(() {
        cursos = listaCursos;
        materias = listaMaterias;
      });
    } catch (e) {
      debugPrint("Erro ao carregar cursos/matérias: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: color.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 820,
        constraints: const BoxConstraints(maxHeight: 680),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Nova Questão",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: color.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 12),

              // === Campos de título e descrição ===
              buildTextField(
                  label: "Título da Questão",
                  hint: "Digite o título da questão",
                  controller: tituloCtrl),
              buildTextArea(
                  label: "Descrição / Contexto da Questão",
                  controller: descricaoCtrl),
              const SizedBox(height: 8),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        buildDropdownField(
                          label: "Tipo da questão",
                          value: tipoQuestao,
                          items: const {
                            "multipla": "Múltipla Escolha",
                            "dissertativa": "Dissertativa",
                          },
                          onChanged: (v) => setState(() => tipoQuestao = v!),
                        ),
                        buildDropdownField(
                          label: "Acesso",
                          value: acesso,
                          items: const {
                            "privada": "Privada",
                            "publica": "Pública",
                          },
                          onChanged: (v) => setState(() => acesso = v!),
                        ),
                        buildDropdownField(
                          label: "Dificuldade",
                          value: dificuldade,
                          items: const {
                            "facil": "Fácil",
                            "medio": "Médio",
                            "dificil": "Difícil",
                          },
                          onChanged: (v) => setState(() => dificuldade = v!),
                        ),
                        buildTextArea(
                            label: "Texto da Questão", controller: textoCtrl),
                        buildCheckboxImageField(),
                        if (tipoQuestao == 'multipla') buildAlternativas(),
                        buildNumberField(
                            label: "Linhas para texto",
                            controller: TextEditingController(text: "0")),
                        buildNumberField(
                            label: "Linhas para desenho",
                            controller: linhasDesenhoCtrl),

                        // === Curso ===
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 140,
                                  child: Text("Curso",
                                      style:
                                          TextStyle(color: color.onSurface))),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: cursoSelecionado,
                                  decoration: _inputDecoration(color),
                                  items: cursos
                                      .map((c) => DropdownMenuItem<int>(
                                            value: c['idCurso'],
                                            child: Text(c['nome']),
                                          ))
                                      .toList(),
                                  onChanged: (v) =>
                                      setState(() => cursoSelecionado = v),
                                  hint: const Text("Selecione o curso"),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // === Disciplina ===
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 140,
                                  child: Text("Disciplina",
                                      style:
                                          TextStyle(color: color.onSurface))),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: materiaSelecionada,
                                  decoration: _inputDecoration(color),
                                  items: materias
                                      .map((m) => DropdownMenuItem<int>(
                                            value: m['idMateria'],
                                            child: Text(m['nome']),
                                          ))
                                      .toList(),
                                  onChanged: (v) =>
                                      setState(() => materiaSelecionada = v),
                                  hint: const Text("Selecione a disciplina"),
                                ),
                              ),
                            ],
                          ),
                        ),

                        buildAssuntoSection(color),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color.outlineVariant),
                      ),
                      child: Text(
                        "Questões públicas se tornam visíveis para todos os usuários.",
                        style: TextStyle(color: color.onSurfaceVariant),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // === BOTÕES ===
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => widget.onOpenChange(false),
                    child: const Text("Cancelar"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: salvarQuestao,
                    child: const Text("Salvar Questão"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // === COMPONENTES AUXILIARES
  // ==========================================================

  InputDecoration _inputDecoration(ColorScheme color) => InputDecoration(
        filled: true,
        fillColor: color.surfaceVariant.withOpacity(0.2),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: color.outlineVariant),
          borderRadius: BorderRadius.circular(6),
        ),
      );

  Widget buildDropdownField({
    required String label,
    required String value,
    required Map<String, String> items,
    required void Function(String?) onChanged,
  }) {
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: TextStyle(color: color.onSurface)),
          ),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: value,
              decoration: _inputDecoration(color),
              items: items.entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required String label,
    String? hint,
    TextEditingController? controller,
  }) {
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
              width: 140,
              child: Text(label, style: TextStyle(color: color.onSurface))),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: _inputDecoration(color).copyWith(hintText: hint),
              style: TextStyle(color: color.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextArea({
    required String label,
    TextEditingController? controller,
  }) {
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 140,
              child: Text(label, style: TextStyle(color: color.onSurface))),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: 4,
              decoration: _inputDecoration(color).copyWith(
                hintText: "Digite aqui...",
              ),
              style: TextStyle(color: color.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNumberField({
    required String label,
    required TextEditingController controller,
  }) {
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
              width: 140,
              child: Text(label, style: TextStyle(color: color.onSurface))),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(color),
              style: TextStyle(color: color.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCheckboxImageField() {
    final color = Theme.of(context).colorScheme;
    return Row(
      children: [
        SizedBox(
            width: 140,
            child: Text("Imagem", style: TextStyle(color: color.onSurface))),
        Checkbox(
          value: hasImage,
          onChanged: (v) => setState(() => hasImage = v ?? false),
        ),
        const Text("Possui imagem?"),
      ],
    );
  }

  Widget buildAlternativas() {
    final color = Theme.of(context).colorScheme;
    const letras = ['a', 'b', 'c', 'd', 'e'];

    return Column(
      children: List.generate(letras.length, (i) {
        final letra = letras[i];
        return Row(
          children: [
            SizedBox(
              width: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("$letra)",
                      style: TextStyle(color: color.onSurfaceVariant)),
                  Checkbox(
                    value: alternativaCorreta == letra,
                    onChanged: (_) {
                      setState(() {
                        alternativaCorreta =
                            alternativaCorreta == letra ? null : letra;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: TextField(
                controller: alternativaCtrls[i],
                decoration: _inputDecoration(color)
                    .copyWith(hintText: "Alternativa ${letra.toUpperCase()}"),
                style: TextStyle(color: color.onSurface),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildAssuntoSection(ColorScheme color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 140,
              child: Text("Assunto", style: TextStyle(color: color.onSurface))),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: novoAssunto,
                  onSubmitted: (v) {
                    if (v.trim().isNotEmpty && !assuntos.contains(v.trim())) {
                      setState(() {
                        assuntos.add(v.trim());
                        novoAssunto.clear();
                      });
                    }
                  },
                  decoration: _inputDecoration(color).copyWith(
                      hintText: "Digite e pressione Enter para adicionar"),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: assuntos
                      .map((a) => Chip(
                            label: Text(a),
                            onDeleted: () => setState(() => assuntos.remove(a)),
                          ))
                      .toList(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // === SALVAR QUESTÃO
  // ==========================================================
  Future<void> salvarQuestao() async {
    // gera alternativas com base no que está na tela
    final letras = ['a', 'b', 'c', 'd', 'e'];
    final alternativas = List.generate(letras.length, (i) {
      return {
        "texto": alternativaCtrls[i].text.trim(),
        "afirmativa": (alternativaCorreta == letras[i]) ? 1 : 0,
      };
    });

    await ApiService.criarQuestaoObjetiva({
      "titulo": tituloCtrl.text.trim(),
      "descricao": descricaoCtrl.text.trim(),
      "texto": textoCtrl.text.trim(),
      "tipo": tipoQuestao,
      "acesso": acesso,
      "idCurso": cursoSelecionado, 
      "idMateria": materiaSelecionada, 
      "idDificuldade": dificuldade == 'facil'
          ? 1
          : dificuldade == 'medio'
              ? 2
              : 3,
      "idProfessor": 1,
      "alternativas": alternativas,
    });

    widget.onOpenChange(false);
  }

  String _mapDificuldade(dynamic valor) {
    if (valor == 1) return "facil";
    if (valor == 2) return "medio";
    if (valor == 3) return "dificil";
    return "medio";
  }
}
