import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // Detecta automaticamente plataforma e define baseUrl
  static String get baseUrl {
    if (kIsWeb) {
      // 🔹 Flutter Web
      return 'http://127.0.0.1:8000';
    } else if (Platform.isAndroid) {
      // 🔹 Android Emulator
      return 'http://10.0.2.2:8000';
    } else {
      // 🔹 Windows / macOS / iOS Simulator
      return 'http://127.0.0.1:8000';
    }
  }

  // ========= QUESTÕES =========

  static Future<List<dynamic>> listarQuestoes() async {
    final res = await http.get(Uri.parse('$baseUrl/questoes/objetivas/'));
    if (res.statusCode == 200) {
      return jsonDecode(utf8.decode(res.bodyBytes));
    }
    throw Exception('Erro ao carregar questões: ${res.statusCode}');
  }

  static Future<void> criarQuestaoObjetiva(Map<String, dynamic> dados) async {
    final uri = Uri.parse('$baseUrl/questoes/objetivas/');
    final request = http.MultipartRequest('POST', uri);

    // Campos básicos
    request.fields['titulo'] = dados['titulo'] ?? '';
    request.fields['descricao'] = dados['descricao'] ?? '';
    request.fields['texto'] = dados['texto'] ?? '';
    request.fields['tipo'] = dados['tipo'] ?? 'multipla';
    request.fields['acesso'] = dados['acesso'] ?? 'privada';
    request.fields['idDificuldade'] = dados['idDificuldade'].toString();
    request.fields['idProfessor'] = dados['idProfessor'].toString();

    // Campos opcionais
    if (dados['idCurso'] != null) {
      request.fields['idCurso'] = dados['idCurso'].toString();
    }
    if (dados['idMateria'] != null) {
      request.fields['idMateria'] = dados['idMateria'].toString();
    }

    // Alternativas e assuntos (sempre string JSON)
    request.fields['alternativas'] = jsonEncode(dados['alternativas']);
    request.fields['assuntos'] = jsonEncode(dados['assuntos'] ?? []);

    // ✅ Upload de imagem - compatível com web e desktop
    try {
      if (dados['imagem'] != null) {
        // se rodando no navegador (Edge/Chrome)
        if (kIsWeb && dados['imagem'] is XFile) {
          final XFile file = dados['imagem'];
          final bytes = await file.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes(
              'imagem',
              bytes,
              filename: file.name,
            ),
          );
        }
        // se for desktop ou mobile
        else if (!kIsWeb && dados['imagem'].toString().isNotEmpty) {
          final filePath = dados['imagem'];
          request.files.add(
            await http.MultipartFile.fromPath(
              'imagem',
              filePath,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('⚠️ Falha ao anexar imagem: $e');
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Erro ao criar questão (${response.statusCode}): $responseBody');
    }
  }

  static Future<void> deletarQuestao(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/questoes/objetivas/$id'));
    if (res.statusCode != 200) {
      throw Exception('Erro ao excluir questão: ${res.statusCode}');
    }
  }

static Future<void> importarQuestoes(String filePath) async {
  var request =
      http.MultipartRequest('POST', Uri.parse('$baseUrl/questoes/importar'));

  // Adiciona o arquivo selecionado
  request.files.add(await http.MultipartFile.fromPath('arquivo', filePath));

  final response = await request.send();
  final body = await response.stream.bytesToString();
  if (response.statusCode >= 200 && response.statusCode < 300) {
    debugPrint('✅ Importação feita: $body');
  } else {
    throw Exception('Erro ao importar questões: ${response.statusCode} - $body');
  }
}

  // ========= PROVAS =========

  static Future<List<dynamic>> listarProvas() async {
    final res = await http.get(Uri.parse('$baseUrl/provas/'));
    if (res.statusCode == 200) {
      return jsonDecode(utf8.decode(res.bodyBytes));
    }
    throw Exception('Erro ao listar provas');
  }

  static Future<void> criarProva(String titulo, String descricao) async {
    final res = await http.post(
      Uri.parse('$baseUrl/provas/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'titulo': titulo, 'descricao': descricao}),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Erro ao criar prova (${res.statusCode})');
    }
  }

  static Future<void> adicionarQuestoesProva(
      int idProva, List<int> idsQuestoes) async {
    final res = await http.post(
      Uri.parse('$baseUrl/provas/$idProva/add-questoes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(idsQuestoes),
    );
    if (res.statusCode != 200) {
      throw Exception('Erro ao vincular questões');
    }
  }

  static Future<Uint8List> gerarQr(int idProva) async {
    final res = await http.get(Uri.parse('$baseUrl/qr/$idProva'));
    if (res.statusCode == 200) return res.bodyBytes;
    throw Exception('Erro ao gerar QR: ${res.statusCode}');
  }

  static Future<Uint8List> gerarPdf(int idProva) async {
    final res = await http.get(Uri.parse('$baseUrl/pdf/$idProva'));
    if (res.statusCode == 200) return res.bodyBytes;
    throw Exception('Erro ao gerar PDF: ${res.statusCode}');
  }

  // ========= RELATÓRIOS =========

  static Future<Map<String, dynamic>> estatisticasTurma(int idTurma) async {
    final res =
        await http.get(Uri.parse('$baseUrl/estatisticas/turma/$idTurma'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Erro ao carregar estatísticas: ${res.statusCode}');
  }

  // ========= PROVAS (AÇÕES DE GERENCIAMENTO) =========

  static Future<void> atualizarProva(int id, Map<String, dynamic> dados) async {
    final res = await http.put(
      Uri.parse('$baseUrl/provas/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dados),
    );
    if (res.statusCode != 200) {
      throw Exception('Erro ao atualizar prova (${res.statusCode})');
    }
  }

  static Future<void> deletarProva(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/provas/$id'));
    if (res.statusCode != 200) {
      throw Exception('Erro ao excluir prova (${res.statusCode})');
    }
  }

  static Future<List<dynamic>> listarQuestoesDaProva(int idProva) async {
    final res = await http.get(Uri.parse('$baseUrl/provas/$idProva/questoes'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Erro ao buscar questões da prova (${res.statusCode})');
  }

  static Future<int> criarProvaComRetorno(Map<String, dynamic> dados) async {
    final res = await http.post(
      Uri.parse('$baseUrl/provas/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dados),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final obj = jsonDecode(res.body);
      return obj['idProva'];
    }
    throw Exception('Erro ao criar prova (${res.statusCode})');
  }

// === Atualizar ordem das questões ===
  static Future<void> atualizarOrdemQuestoes(
      int idProva, List<int> novaOrdem) async {
    final res = await http.put(
      Uri.parse('$baseUrl/provas/$idProva/ordenar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(novaOrdem),
    );
    if (res.statusCode != 200) {
      throw Exception('Erro ao atualizar ordem (${res.statusCode})');
    }
  }

// === Remover questão da prova ===
  static Future<void> removerQuestaoProva(int idProva, int idQuestao) async {
    final res = await http.delete(
        Uri.parse('$baseUrl/provas/$idProva/remover-questao/$idQuestao'));
    if (res.statusCode != 200) {
      throw Exception('Erro ao remover questão da prova (${res.statusCode})');
    }
  }

// === CURSOS E DISCIPLINAS ===
  static Future<List<dynamic>> listarCursos() async {
    final res = await http.get(Uri.parse('$baseUrl/public/cursos'));
    if (res.statusCode == 200) {
      return jsonDecode(utf8.decode(res.bodyBytes));
    }
    throw Exception('Erro ao carregar cursos (${res.statusCode})');
  }

  static Future<List<dynamic>> listarMaterias() async {
    final res = await http.get(Uri.parse('$baseUrl/public/materias'));
    if (res.statusCode == 200) {
      return jsonDecode(utf8.decode(res.bodyBytes));
    }
    throw Exception('Erro ao carregar matérias (${res.statusCode})');
  }

  static Future<Map<String, dynamic>> corrigirGabarito(XFile file) async {
    final uri = Uri.parse('$baseUrl/correcao/gabarito');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(body);
    } else {
      throw Exception('Erro ao corrigir (${response.statusCode}): $body');
    }
  }
}
