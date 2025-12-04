import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
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
  bool conectado = false;

  @override
  void initState() {
    super.initState();
    iniciarCamera();
  }

  Future<void> iniciarCamera() async {
    final cameras = await availableCameras();
    controller = CameraController(cameras.first, ResolutionPreset.low,
        imageFormatGroup: ImageFormatGroup.bgra8888);
    await controller!.initialize();
    setState(() {});
    // Conecta WebSocket
    channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.0.104:8000/correcao/stream'), // seu IP
    );
    channel!.stream.listen((msg) {
      final data = jsonDecode(msg);
      setState(() => resultado = data);
    });
    conectado = true;
    // Envia frames a cada meio segundo
    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (!mounted || controller == null || !controller!.value.isStreamingImages) return;
    });
    controller!.startImageStream((CameraImage image) async {
      if (!conectado) return;
      // converte imagem para JPEG base64
      final bytes = image.planes[0].bytes;
      channel!.sink.add(base64Encode(bytes));
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                  "Prova ${resultado!['idProva']} - "
                  "Nota: ${resultado!['nota']}\n"
                  "Acertos: ${resultado!['acertos']}",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            )
        ],
      ),
    );
  }
}