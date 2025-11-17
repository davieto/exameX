import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../layout/desktop_layout.dart';
import '../widgets/ui/app_card.dart';
import '../widgets/ui/app_button.dart';

class GabaritosDesktopPage extends StatelessWidget {
  const GabaritosDesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return LayoutBuilder(builder: (ctx, c) {
      if (c.maxWidth < 1024) return const SizedBox.shrink();

      return DesktopLayout(
          content: Center(
              child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gabaritos',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: color.onBackground)),
                    const SizedBox(height: 6),
                    Text('Corrija provas através de QR codes e gabaritos',
                        style: TextStyle(
                            color: color.onSurfaceVariant, fontSize: 16))
                  ])),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: AppCard(
              child: Column(
                children: [
                  CircleAvatar(
                      radius: 40,
                      backgroundColor: color.primary.withOpacity(0.1),
                      child:
                          Icon(LucideIcons.qrCode, size: 40, color: color.primary)),
                  const SizedBox(height: 24),
                  Text('Escanear QR Code',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: color.onBackground)),
                  const SizedBox(height: 8),
                  Text(
                      'Use a câmera para ler o QR code da prova e iniciar a correção automática.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: color.onSurfaceVariant, fontSize: 14)),
                  const SizedBox(height: 24),
                  AppButton(
                      label: 'Iniciar Escaneamento',
                      variant: ButtonVariant.primary,
                      fullWidth: true,
                      onPressed: () {})
                ],
              ),
            )),
            const SizedBox(width: 24),
            Expanded(
                child: AppCard(
              child: Column(
                children: [
                  CircleAvatar(
                      radius: 40,
                      backgroundColor: color.primary.withOpacity(0.1),
                      child:
                          Icon(LucideIcons.upload, size: 40, color: color.primary)),
                  const SizedBox(height: 24),
                  Text('Upload de Gabarito',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: color.onBackground)),
                  const SizedBox(height: 8),
                  Text(
                      'Faça upload de imagens de gabaritos para processamento em lote.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: color.onSurfaceVariant, fontSize: 14)),
                  const SizedBox(height: 24),
                  AppButton(
                      label: 'Selecionar Arquivos',
                      variant: ButtonVariant.outline,
                      fullWidth: true,
                      onPressed: () {})
                ],
              ),
            ))
          ]),
          const SizedBox(height: 40),
          AppCard(
              padding: const EdgeInsets.all(24),
              color: color.surfaceVariant.withOpacity(0.2),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Como funciona a correção',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: color.onBackground)),
                    const SizedBox(height: 16),
                    _infoStep(context, color, 1,
                        'Cada prova possui um QR code único gerado automaticamente.'),
                    _infoStep(context, color, 2,
                        'O aluno preenche o gabarito de quadradinhos com suas respostas.'),
                    _infoStep(context, color, 3,
                        'O sistema lê o QR code e identifica automaticamente as respostas marcadas.'),
                    _infoStep(context, color, 4,
                        'As notas são calculadas e os resultados ficam disponíveis nos relatórios.')
                  ]))
        ]),
      )));
    });
  }

  Widget _infoStep(BuildContext context, ColorScheme color, int index, String text) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.only(right: 12, top: 2),
            decoration: BoxDecoration(
                color: color.primary, borderRadius: BorderRadius.circular(50)),
            alignment: Alignment.center,
            child: Text('$index',
                style: TextStyle(
                    color: color.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
              child: Text(text,
                  style: TextStyle(
                      fontSize: 14,
                      color: color.onSurfaceVariant,
                      height: 1.4)))
        ]));
  }
}