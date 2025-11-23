import 'package:flutter/material.dart';
import '../layout/desktop_layout.dart';
import '../widgets/ui/app_button.dart';

class NotFoundDesktopPage extends StatelessWidget {
  const NotFoundDesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth < 1024) return const SizedBox.shrink();

      return DesktopLayout(
        content: Center(
          child: Container(
            alignment: Alignment.center,
            color: color.surfaceContainerHighest.withOpacity(0.2),
            height: MediaQuery.of(context).size.height - 64, // abaixo do TopBar
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '404',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color.onSurface),
                ),
                const SizedBox(height: 16),
                Text(
                  'Oops! Página não encontrada',
                  style: TextStyle(
                    fontSize: 20,
                    color: color.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Voltar para a página inicial',
                  variant: ButtonVariant.ghost,
                  onPressed: () => Navigator.pushNamed(context, '/'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}