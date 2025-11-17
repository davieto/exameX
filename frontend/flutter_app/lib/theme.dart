import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ColorScheme colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: const Color(0xFF9B1C3F),
  onPrimary: Colors.white,
  secondary: const Color(0xFFF2D7DD),
  onSecondary: const Color(0xFF4B1B2B),
  error: Colors.red,
  onError: Colors.white,
  surface: const Color(0xFFFFFFFF),
  onSurface: const Color(0xFF1F1B1C),
);

ThemeData buildAppTheme() {
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 0,
      centerTitle: true,
    ),
  );
}