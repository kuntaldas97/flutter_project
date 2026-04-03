// ============================================================
// game_screen.dart
// Main game screen: renders the board, scoreboard, status bar,
// and action buttons.  Consumes GameController via Provider.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/game_controller.dart';
import '../models/game_state.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../widgets/game_board.dart';
import '../widgets/score_board.dart';

class GameScreen extends StatelessWidget {
  final int boardSize;
  final String gameMode;
  final String difficulty;

  const GameScreen({
    super.key,
    required this.boardSize,
    required this.gameMode,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameController()
        ..newGame(
          size: boardSize,
          gameMode: gameMode,
          difficulty: difficulty,
        ),
      child: const _GameView(),
    );
  }
}

class _GameView extends StatelessWidget {
  const _GameView();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<GameController>();
    final state = ctrl.state;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.gameMode == kModePlayerVsAI
              ? 'vs AI · ${state.difficulty}'
              : 'Player vs Player',
          style: const TextStyle(fontSize: 16),
        ),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'New round',
            onPressed: ctrl.restartRound,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // ── Scoreboard ──────────────────────────────────────
            ScoreBoard(
              labelX: state.playerX.name,
              labelO: state.playerO.name,
              scoreX: state.scoreX,
              scoreO: state.scoreO,
              scoreDraw: state.scoreDraw,
            ),

            const SizedBox(height: 16),

            // ── Status bar ──────────────────────────────────────
            _StatusBar(state: state, isAIThinking: ctrl.isAIThinking),

            const SizedBox(height: 16),

            // ── Board ───────────────────────────────────────────
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GameBoard(
                    board: state.board,
                    size: state.size,
                    winningCells: state.winningCells,
                    isEnabled: state.status == GameStatus.playing &&
                        !state.currentPlayer.isAI &&
                        !ctrl.isAIThinking,
                    onTileTapped: ctrl.onCellTapped,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Action buttons ──────────────────────────────────
            _ActionBar(state: state, ctrl: ctrl),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Status bar ────────────────────────────────────────────────
class _StatusBar extends StatelessWidget {
  final GameState state;
  final bool isAIThinking;

  const _StatusBar({required this.state, required this.isAIThinking});

  @override
  Widget build(BuildContext context) {
    final (text, color) = _statusInfo();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(text),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isAIThinking) ...[
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: color,
                ),
              ),
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  (String, Color) _statusInfo() {
    if (isAIThinking) return ('AI is thinking…', kPrimary);

    switch (state.status) {
      case GameStatus.won:
        final winnerName = state.winningCells.isNotEmpty
            ? (state.board[state.winningCells.first] == kPlayerX
                ? state.playerX.name
                : state.playerO.name)
            : '?';
        return ('🎉 $winnerName wins!', kWinHighlight);
      case GameStatus.draw:
        return ("It's a draw!", kTextSecondary);
      case GameStatus.playing:
        final name = state.currentPlayer.name;
        final marker = state.currentPlayer.marker;
        return ("$name's turn  [$marker]", markerColor(marker));
      case GameStatus.idle:
        return ('Ready', kTextSecondary);
    }
  }
}

// ── Action bar ────────────────────────────────────────────────
class _ActionBar extends StatelessWidget {
  final GameState state;
  final GameController ctrl;

  const _ActionBar({required this.state, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final gameOver = state.status == GameStatus.won ||
        state.status == GameStatus.draw;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.home_outlined, size: 18),
              label: const Text('Home'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              icon: Icon(gameOver ? Icons.play_arrow : Icons.refresh, size: 18),
              label: Text(gameOver ? 'Play Again' : 'Restart'),
              onPressed: ctrl.restartRound,
            ),
          ),
        ],
      ),
    );
  }
}
