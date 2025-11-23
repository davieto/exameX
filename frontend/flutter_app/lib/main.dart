import 'package:flutter/material.dart';
import 'theme.dart';
import 'router.dart';

void main() => runApp(const ExameXApp());

class ExameXApp extends StatelessWidget {
  const ExameXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExameX',
      debugShowCheckedModeBanner: false,

      // === Tema global ===
      theme: buildAppTheme(),

      // === Sistema de rotas híbrido (mobile + desktop) ===
      onGenerateRoute: generateRoute,

      // === Rota inicial ===
      initialRoute: '/home',

      // === Animação de transição mais suave entre rotas ===
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}