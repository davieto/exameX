import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StreamOMRPage extends StatefulWidget {
  const StreamOMRPage({super.key});

  @override
  State<StreamOMRPage> createState() => _StreamOMRPageState();
}

class _StreamOMRPageState extends State<StreamOMRPage> {
  CameraController? controller;
  WebSocketChannel? channel;
  Map<String, dynamic>? resultado;
  Timer? timer;
  bool conectado = false;

  @override
  void initState() {
    super.initState();
    iniciarCamera();
  }

  /// Inicializa a câmera e abre a conexão WebSocket
  Future<void> iniciarCamera() async {
    try {
      final cameras = await availableCameras();
      controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller!.initialize();
      setState(() {});

      const String backendIp = "192.168.1.7";
      channel = WebSocketChannel.connect(
        Uri.parse('ws://$backendIp:8000/correcao/stream'),
      );

      // Escuta mensagens do servidor
      channel!.stream.listen((msg) {
        final data = jsonDecode(msg);
        setState(() => resultado = data);
      }, onError: (e) {
        print("❌ Erro WebSocket: $e");
      });

      conectado = true;
      print("✅ Conectado ao servidor WebSocket");

      // 🕓 tira uma foto JPEG a cada 2 segundos e envia
      timer = Timer.periodic(const Duration(seconds: 2), (_) async {
        if (controller != null && controller!.value.isInitialized && conectado) {
          try {
            final XFile foto = await controller!.takePicture();
            final bytes = await foto.readAsBytes();
            channel!.sink.add(base64Encode(bytes));
            print("📸 Frame enviado: ${bytes.length} bytes");
          } catch (e) {
            print("Erro ao enviar frame: $e");
          }
        }
      });
    } catch (e) {
      print("❌ Erro ao iniciar câmera: $e");
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    controller?.dispose();
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),
          if (resultado != null)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(12),
                child: Text(
                  "📘 Prova ${resultado!['idProva']}\n"
                  "✔️ Nota: ${resultado!['nota']} — "
                  "Acertos: ${resultado!['acertos']}/${resultado!['totalQuestoes']}",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}