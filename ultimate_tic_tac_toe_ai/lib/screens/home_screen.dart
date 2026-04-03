// ============================================================
// home_screen.dart
// Landing screen: choose board size, game mode, and difficulty,
// then launch the game.
// ============================================================

import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../widgets/size_selector.dart';
import 'game_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _boardSize = kDefaultBoardSize;
  String _gameMode = kModePlayerVsAI;
  String _difficulty = kHard;

  void _startGame() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameScreen(
          boardSize: _boardSize,
          gameMode: _gameMode,
          difficulty: _difficulty,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroBanner(),
              const SizedBox(height: 28),

              // ── Board size ───────────────────────────────────
              SizeSelector(
                selectedSize: _boardSize,
                onSizeChanged: (s) => setState(() => _boardSize = s),
              ),
              const SizedBox(height: 24),

              // ── Game mode ────────────────────────────────────
              _SectionLabel('Game Mode'),
              const SizedBox(height: 8),
              _OptionRow(
                options: kGameModes,
                selected: _gameMode,
                onSelect: (m) => setState(() => _gameMode = m),
              ),
              const SizedBox(height: 24),

              // ── Difficulty (only for PvAI) ───────────────────
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                child: _gameMode == kModePlayerVsAI
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionLabel('AI Difficulty'),
                          const SizedBox(height: 8),
                          _OptionRow(
                            options: kDifficultyLevels,
                            selected: _difficulty,
                            onSelect: (d) => setState(() => _difficulty = d),
                            colors: const [
                              Color(0xFF00D084),  // Easy  = green
                              Color(0xFFFFB347),  // Medium = orange
                              Color(0xFFFF6584),  // Hard   = red
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              // ── Start button ──────────────────────────────────
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'START GAME',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 1.5),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Small reusable sub-widgets ────────────────────────────────

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF9B59B6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ultimate\nTic Tac Toe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'AI-powered · Up to 7×7',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Text('✕ ○', style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: kTextSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;
  final List<Color>? colors;

  const _OptionRow({
    required this.options,
    required this.selected,
    required this.onSelect,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(options.length, (i) {
        final opt = options[i];
        final isSelected = opt == selected;
        final activeColor = colors?[i] ?? kPrimary;

        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: i < options.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? activeColor.withOpacity(0.15) : kTileBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? activeColor : kDivider,
                  width: 1.5,
                ),
              ),
              child: Text(
                opt,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? activeColor : kTextSecondary,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w400,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
