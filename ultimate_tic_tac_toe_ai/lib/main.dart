// ============================================================
// main.dart
// Entry point for Ultimate Tic Tac Toe AI.
//
// Registers the app theme and navigates to HomeScreen.
// Provider is included as a dev-dependency for GameController.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/theme.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode for consistent mobile UX.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Extend content behind status bar (immersive feel).
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF14141F),
  ));

  runApp(const UltimateTicTacToeApp());
}

class UltimateTicTacToeApp extends StatelessWidget {
  const UltimateTicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ultimate Tic Tac Toe AI',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const HomeScreen(),
    );
  }
}
