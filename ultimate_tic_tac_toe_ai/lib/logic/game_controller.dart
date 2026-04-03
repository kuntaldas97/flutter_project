// ============================================================
// game_controller.dart
// Central state manager (ChangeNotifier) that coordinates:
//   • Player moves
//   • AI moves (run in an Isolate to keep the UI smooth)
//   • Win / draw detection
//   • Score tracking
//   • Board resets
//
// Usage:
//   ChangeNotifierProvider(
//     create: (_) => GameController(),
//     child: GameScreen(),
//   )
// ============================================================

import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../logic/win_checker.dart';
import '../logic/ai_engine.dart';
import '../utils/constants.dart';

/// Message sent to the AI isolate.
class _AIRequest {
  final List<String> board;
  final int size;
  final String aiMarker;
  final String difficulty;
  const _AIRequest(this.board, this.size, this.aiMarker, this.difficulty);
}

/// Top-level function required by Isolate.spawn.
void _aiIsolateEntry(List<dynamic> args) {
  final sendPort = args[0] as SendPort;
  final req = args[1] as _AIRequest;
  final move = AIEngine.getBestMove(
    board: req.board,
    size: req.size,
    aiMarker: req.aiMarker,
    difficulty: req.difficulty,
  );
  sendPort.send(move);
}

class GameController extends ChangeNotifier {
  // ── State ────────────────────────────────────────────────────
  late GameState _state;
  bool _isAIThinking = false;

  // ── Getters ──────────────────────────────────────────────────
  GameState get state => _state;
  bool get isAIThinking => _isAIThinking;

  // ── Constructor ──────────────────────────────────────────────
  GameController() {
    _state = GameState.initial();
  }

  // ================================================================
  // Configuration – called from settings / home screen
  // ================================================================

  /// Start a brand-new game with the given settings, resetting scores.
  void newGame({
    required int size,
    required String gameMode,
    required String difficulty,
  }) {
    _state = GameState.initial(
      size: size,
      gameMode: gameMode,
      difficulty: difficulty,
    );
    _isAIThinking = false;
    notifyListeners();
    _triggerAIIfNeeded();
  }

  /// Reset the board but keep accumulated scores and settings.
  void restartRound() {
    _state = GameState.initial(
      size: _state.size,
      gameMode: _state.gameMode,
      difficulty: _state.difficulty,
      scoreX: _state.scoreX,
      scoreO: _state.scoreO,
      scoreDraw: _state.scoreDraw,
    );
    _isAIThinking = false;
    notifyListeners();
    _triggerAIIfNeeded();
  }

  // ================================================================
  // Move handling
  // ================================================================

  /// Called when a human player taps cell [index].
  void onCellTapped(int index) {
    if (!_canPlay(index)) return;

    _applyMove(index, _state.currentPlayer.marker);
  }

  /// Places [marker] at [index], then checks for terminal states.
  void _applyMove(int index, String marker) {
    final newBoard = List<String>.from(_state.board);
    newBoard[index] = marker;

    final winLen = kWinLength[_state.size]!;
    final winResult = WinChecker.check(
      board: newBoard,
      size: _state.size,
      winLen: winLen,
    );

    GameStatus newStatus;
    int newScoreX = _state.scoreX;
    int newScoreO = _state.scoreO;
    int newScoreDraw = _state.scoreDraw;
    List<int> winCells = const [];

    if (winResult.hasWinner) {
      newStatus = GameStatus.won;
      winCells = winResult.winningCells;
      if (winResult.winner == kPlayerX) {
        newScoreX++;
      } else {
        newScoreO++;
      }
    } else if (WinChecker.isBoardFull(newBoard)) {
      newStatus = GameStatus.draw;
      newScoreDraw++;
    } else {
      newStatus = GameStatus.playing;
    }

    // Switch current player only if game continues.
    final nextPlayer = newStatus == GameStatus.playing
        ? (_state.currentPlayer.side == PlayerSide.x
            ? _state.playerO
            : _state.playerX)
        : _state.currentPlayer;

    _state = _state.copyWith(
      board: newBoard,
      currentPlayer: nextPlayer,
      status: newStatus,
      winningCells: winCells,
      scoreX: newScoreX,
      scoreO: newScoreO,
      scoreDraw: newScoreDraw,
    );

    notifyListeners();

    // If game is still running and it's the AI's turn, schedule AI move.
    if (newStatus == GameStatus.playing) {
      _triggerAIIfNeeded();
    }
  }

  // ================================================================
  // AI integration
  // ================================================================

  /// Schedules an AI move in a background isolate to avoid UI jank.
  void _triggerAIIfNeeded() {
    if (!_state.isAITurn || _isAIThinking) return;
    _isAIThinking = true;
    notifyListeners();
    _computeAIMove();
  }

  Future<void> _computeAIMove() async {
    final board = List<String>.from(_state.board);
    final size = _state.size;
    final aiMarker = _state.currentPlayer.marker;
    final difficulty = _state.difficulty;

    int move;

    // Use Isolate on native platforms; direct call on web (no Isolate support).
    if (kIsWeb) {
      move = AIEngine.getBestMove(
        board: board,
        size: size,
        aiMarker: aiMarker,
        difficulty: difficulty,
      );
    } else {
      final receivePort = ReceivePort();
      await Isolate.spawn(
        _aiIsolateEntry,
        [receivePort.sendPort, _AIRequest(board, size, aiMarker, difficulty)],
      );
      move = await receivePort.first as int;
      receivePort.close();
    }

    _isAIThinking = false;

    // Guard: state may have changed while AI was thinking.
    if (_state.status == GameStatus.playing &&
        _state.currentPlayer.isAI &&
        move >= 0 &&
        _state.isCellEmpty(move)) {
      _applyMove(move, _state.currentPlayer.marker);
    } else {
      notifyListeners();
    }
  }

  // ================================================================
  // Guard helpers
  // ================================================================

  /// Returns true only when a human player may legally tap the cell.
  bool _canPlay(int index) {
    if (_state.status != GameStatus.playing) return false;
    if (_state.currentPlayer.isAI) return false;
    if (!_state.isCellEmpty(index)) return false;
    if (_isAIThinking) return false;
    return true;
  }
}
