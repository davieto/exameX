import 'package:flutter/material.dart';
import 'widgets/responsive_layout.dart';

// ==== Telas Mobile ====
import 'screens/home_screen.dart';
import 'screens/gabarito_screen.dart';
import 'screens/questoes_screen.dart';
import 'screens/prepare_provas_screen.dart';
import 'screens/nova_prova_screen.dart';
import 'screens/compartilhar_screen.dart';
import 'screens/not_found_screen.dart';

// ==== Telas Desktop ====
import 'desktop/pages/home_desktop.dart';
import 'desktop/pages/avaliacoes_desktop.dart';
import 'desktop/pages/gabaritos_desktop.dart';
import 'desktop/pages/questoes_desktop.dart';
import 'desktop/pages/relatorios_desktop.dart';
import 'desktop/pages/not_found_desktop.dart';
import 'desktop/pages/ui_preview.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {

    // ==== Início / Home ====
    case '/home':
      return MaterialPageRoute(
        builder: (_) => const ResponsiveLayout(
          mobile: HomeScreen(),
          desktop: HomeDesktopPage(),
        ),
      );

      case '/ui-preview':
      return MaterialPageRoute(
      builder: (_) => const ResponsiveLayout(
      mobile: NotFoundScreen(),
      desktop: UIPreviewDesktopPage(),
      ),
    );

    // ==== Avaliações ====
    case '/avaliacoes':
      return MaterialPageRoute(
        builder: (_) => const ResponsiveLayout(
          mobile: HomeScreen(), // ou outra tela mobile se existir
          desktop: AvaliacoesDesktopPage(),
        ),
      );

    // ==== Gabaritos ====
    case '/gabaritos':
      return MaterialPageRoute(
        builder: (_) => const ResponsiveLayout(
          mobile: GabaritoScreen(),
          desktop: GabaritosDesktopPage(),
        ),
      );

    // ==== Questões ====
    case '/questoes':
      return MaterialPageRoute(
        builder: (_) => const ResponsiveLayout(
          mobile: QuestoesScreen(),
          desktop: QuestoesDesktopPage(),
        ),
      );

    // ==== Relatórios ====
    case '/relatorios':
      return MaterialPageRoute(
        builder: (_) => const ResponsiveLayout(
          mobile: PrepareProvasScreen(), // substitua se tiver tela mobile específica
          desktop: RelatoriosDesktopPage(),
        ),
      );

    // ==== Nova Prova / Preparar Prova / Compartilhar ====
    case '/prepare-provas':
      return MaterialPageRoute(builder: (_) => const PrepareProvasScreen());

    case '/nova-prova':
      return MaterialPageRoute(builder: (_) => const NovaProvaScreen());

    case '/compartilhe':
      return MaterialPageRoute(builder: (_) => const CompartilharScreen());

    // ==== Fallback Not found ====
    default:
      return MaterialPageRoute(
        builder: (_) => const ResponsiveLayout(
          mobile: NotFoundScreen(),
          desktop: NotFoundDesktopPage(),
        ),
      );
  }
}