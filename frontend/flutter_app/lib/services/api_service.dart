import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class ApiService {
  static const baseUrl = 'http://10.0.2.2:8000';

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
      throw Exception('Erro ao criar prova');
    }
  }

  static Future<Uint8List> gerarQr(int idProva) async {
  final res = await http.get(Uri.parse('$baseUrl/qr/$idProva'));
  if (res.statusCode == 200) return res.bodyBytes;
  throw Exception('Erro ao gerar QR Code');
}

static Future<Uint8List> gerarPdf(int idProva) async {
  final res = await http.get(Uri.parse('$baseUrl/pdf/$idProva'));
  if (res.statusCode == 200) return res.bodyBytes;
  throw Exception('Erro ao gerar PDF');
}

static Future<void> exportarCsv() async {
  final res = await http.get(Uri.parse('$baseUrl/export/'));
  if (res.statusCode != 200) throw Exception('Erro ao exportar CSV');
}

static Future<List<dynamic>> listarQuestoes() async {
  final res = await http.get(Uri.parse('$baseUrl/questoes/objetivas/'));
  if (res.statusCode == 200) {
    return jsonDecode(utf8.decode(res.bodyBytes));
  } else {
    throw Exception('Erro ao buscar questões');
  }
}

static Future<void> criarQuestaoObjetiva(Map<String, dynamic> dados) async {
  final req = http.MultipartRequest('POST', Uri.parse('$baseUrl/questoes/objetivas/'));
  req.fields['titulo'] = dados['titulo'];
  req.fields['idDificuldade'] = dados['idDificuldade'].toString();
  req.fields['idProfessor'] = dados['idProfessor'].toString();
  req.fields['alternativas'] = jsonEncode(dados['alternativas']);
  if (dados['imagem'] != null) {
    req.files.add(await http.MultipartFile.fromPath('imagem', dados['imagem']));
  }
  final res = await req.send();
  if (res.statusCode < 200 || res.statusCode > 299) {
    throw Exception('Erro ao criar questão');
  }
}

static Future<void> deletarQuestao(int id) async {
  final res = await http.delete(Uri.parse('$baseUrl/questoes/objetivas/$id'));
  if (res.statusCode != 200) {
    throw Exception('Erro ao deletar questão');
  }
}

}