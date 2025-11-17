import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
//import 'screens/login_screen.dart';
import 'screens/gabarito_screen.dart';
//import 'screens/provas_criar_screen.dart';
import 'screens/nova_prova_screen.dart';
import 'screens/questoes_screen.dart';
import 'screens/compartilhar_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/prepare_provas_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    //case '/login':
    //  return MaterialPageRoute(builder: (_) => const LoginScreen());
    case '/home':
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    case '/gabarito':
      return MaterialPageRoute(builder: (_) => const GabaritoScreen());
    case '/prepare-provas':
      return MaterialPageRoute(builder: (_) => const PrepareProvasScreen());
    case '/nova-prova':
      return MaterialPageRoute(builder: (_) => const NovaProvaScreen());
    case '/questoes':
      return MaterialPageRoute(builder: (_) => const QuestoesScreen());
    case '/compartilhe':
      return MaterialPageRoute(builder: (_) => const CompartilharScreen());
    default:
      return MaterialPageRoute(builder: (_) => const NotFoundScreen());
  }
}