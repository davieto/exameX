import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta completa baseada no design React/Tailwind (`index.css`)
final ColorScheme colorScheme = const ColorScheme(
  brightness: Brightness.light,

  // === Cores principais ===
  primary: Color(0xFF9B1C3F), // hsl(348 44% 50%)
  onPrimary: Colors.white,

  secondary: Color(0xFFF2D7DD), // hsl(348 44% 94%)
  onSecondary: Color(0xFF4B1B2B),

  // === Fundo e superfícies ===
  background: Color(0xFFFFFFFF), // branco puro
  onBackground: Color(0xFF2A0E11), // hsl(348 44% 15%)
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF2A0E11),
  surfaceVariant: Color(0xFFF4EFF0), // hsl(348 20% 96%)

  // === Erros / destrutivo ===
  error: Color(0xFFE53935),
  onError: Colors.white,

  // === Outline, bordas, inputs ===
  outline: Color(0xFFE5DADC),
  outlineVariant: Color(0xFFF1E6E8),

  // === Acentos ===
  tertiary: Color(0xFFEAE2E3),
  onTertiary: Color(0xFF2A0E11),

  // === Extras de contraste ===
  inverseSurface: Color(0xFF2A0E11),
  onInverseSurface: Color(0xFFFAFAFA),
  inversePrimary: Color(0xFFB64555),

  shadow: Color(0x29000000),
);

/// Tema global (mobile + desktop)
ThemeData buildAppTheme() {
  final baseTextTheme = GoogleFonts.poppinsTextTheme();

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,

    // === Tipografia ===
    textTheme: baseTextTheme.copyWith(
      displayLarge:
          baseTextTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
      headlineMedium:
          baseTextTheme.headlineMedium?.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
      titleMedium: baseTextTheme.titleMedium?.copyWith(fontSize: 18),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    ),

    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
    dividerColor: colorScheme.outlineVariant,

    // === AppBar (para mobile) ===
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: baseTextTheme.titleLarge?.copyWith(
        color: colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),

    // === Botões ===
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        textStyle: baseTextTheme.labelLarge,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: baseTextTheme.labelLarge,
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: baseTextTheme.labelLarge,
        foregroundColor: colorScheme.primary,
      ),
    ),

    // === Campos de texto ===
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
      hintStyle:
          baseTextTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
      ),
    ),

    // === Cards / Containers ===
 cardTheme: CardThemeData(
  color: colorScheme.surface,
  elevation: 1,
  shadowColor: Colors.black.withOpacity(0.05),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(color: colorScheme.outlineVariant),
  ),
),

    // === Scrollbars, tooltips, popovers ===
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: MaterialStateProperty.all(colorScheme.outline),
      trackColor: MaterialStateProperty.all(colorScheme.surfaceVariant),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: colorScheme.onBackground.withOpacity(0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle:
          baseTextTheme.bodySmall?.copyWith(color: colorScheme.onPrimary),
    ),
  );
}