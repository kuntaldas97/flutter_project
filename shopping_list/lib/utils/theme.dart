// ============================================================
// theme.dart
// App-wide Material theme, colours, text styles, and
// decoration helpers for Ultimate Tic Tac Toe AI.
// ============================================================

import 'package:flutter/material.dart';

// --------------- Colour Palette ---------------

const Color kPrimary = Color(0xFF6C63FF);      // Indigo-violet
const Color kPrimaryDark = Color(0xFF4B44CC);
const Color kAccent = Color(0xFFFF6584);        // Coral for Player O
const Color kPlayerXColor = Color(0xFF6C63FF);  // Violet for X
const Color kPlayerOColor = Color(0xFFFF6584);  // Coral for O
const Color kWinHighlight = Color(0xFF00D084);  // Green win highlight
const Color kBoardBg = Color(0xFF1E1E2E);       // Dark board background
const Color kTileBg = Color(0xFF2A2A3E);        // Tile background
const Color kTileHover = Color(0xFF3A3A50);     // Tile hover/pressed
const Color kScaffoldBg = Color(0xFF14141F);    // App background
const Color kCardBg = Color(0xFF1E1E2E);
const Color kTextPrimary = Color(0xFFE8E8FF);
const Color kTextSecondary = Color(0xFF9898BB);
const Color kDivider = Color(0xFF2E2E4E);

// --------------- Theme Data ---------------

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: kScaffoldBg,
    colorScheme: const ColorScheme.dark(
      primary: kPrimary,
      secondary: kAccent,
      surface: kCardBg,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: kTextPrimary,
    ),
    cardTheme: const CardThemeData(
      color: kCardBg,
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kPrimary,
        side: const BorderSide(color: kPrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: kScaffoldBg,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: kTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(color: kTextPrimary),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: kTextPrimary,
        fontSize: 32,
        fontWeight: FontWeight.w800,
      ),
      headlineMedium: TextStyle(
        color: kTextPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: TextStyle(
        color: kTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: kTextPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: kTextSecondary, fontSize: 14),
      labelLarge: TextStyle(
        color: kTextPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
    dividerColor: kDivider,
    fontFamily: 'Roboto',
  );
}

// --------------- Decoration Helpers ---------------

/// Gradient decoration for hero banners and headers.
BoxDecoration heroGradientDecoration() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF6C63FF), Color(0xFF9B59B6)],
    ),
  );
}

/// Card decoration with subtle border.
BoxDecoration cardDecoration({Color? color, double radius = 16}) {
  return BoxDecoration(
    color: color ?? kCardBg,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: kDivider, width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

/// Returns the display colour for a given player marker.
Color markerColor(String marker) {
  if (marker == 'X') return kPlayerXColor;
  if (marker == 'O') return kPlayerOColor;
  return kTextSecondary;
}
