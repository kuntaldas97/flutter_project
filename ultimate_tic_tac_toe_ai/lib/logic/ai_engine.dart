// ============================================================
// ai_engine.dart
// AI opponent for Ultimate Tic Tac Toe AI.
//
// Algorithm selection
// -------------------
// 3×3  →  Minimax with Alpha-Beta pruning (exhaustive, optimal)
// 4×7  →  Heuristic search with limited depth + threat scoring
//
// Difficulty affects search depth and random noise injection:
//   Easy   → depth 1  + 80 % chance of random legal move
//   Medium → depth 3  + 30 % chance of random legal move
//   Hard   → full depth, no randomness
// ============================================================

import 'dart:math';
import '../utils/constants.dart';
import '../logic/win_checker.dart';

class AIEngine {
  AIEngine._(); // static utility

  static final _rng = Random();

  // ================================================================
  // Public API
  // ================================================================

  /// Returns the best board index for the AI to play.
  ///
  /// [board]      current board state (flat list, '' = empty)
  /// [size]       board dimension
  /// [aiMarker]   the AI's marker ('X' or 'O')
  /// [difficulty] kEasy / kMedium / kHard
  static int getBestMove({
    required List<String> board,
    required int size,
    required String aiMarker,
    required String difficulty,
  }) {
    final winLen = kWinLength[size]!;
    final humanMarker = aiMarker == kPlayerX ? kPlayerO : kPlayerX;
    final empties = _emptyIndices(board);

    if (empties.isEmpty) return -1;

    // ── Easy: mostly random ──────────────────────────────────────
    if (difficulty == kEasy) {
      if (_rng.nextDouble() < 0.80) return empties[_rng.nextInt(empties.length)];
    }

    // ── Medium: some random ──────────────────────────────────────
    if (difficulty == kMedium) {
      if (_rng.nextDouble() < 0.30) return empties[_rng.nextInt(empties.length)];
    }

    // ── Hard / fallthrough: best move ────────────────────────────
    final depth = kDepthLimit[difficulty]!;

    if (size == 3) {
      // Exhaustive minimax for 3×3
      return _minimaxRoot(
        board: List.from(board),
        size: size,
        winLen: winLen,
        aiMarker: aiMarker,
        humanMarker: humanMarker,
        maxDepth: depth,
      );
    } else {
      // Heuristic for larger boards
      return _heuristicRoot(
        board: List.from(board),
        size: size,
        winLen: winLen,
        aiMarker: aiMarker,
        humanMarker: humanMarker,
        maxDepth: depth,
      );
    }
  }

  // ================================================================
  // Minimax with Alpha-Beta pruning (3×3)
  // ================================================================

  static int _minimaxRoot({
    required List<String> board,
    required int size,
    required int winLen,
    required String aiMarker,
    required String humanMarker,
    required int maxDepth,
  }) {
    int bestScore = kScoreLose;
    int bestMove = _emptyIndices(board).first;

    for (final idx in _emptyIndices(board)) {
      board[idx] = aiMarker;
      final score = _minimax(
        board: board,
        size: size,
        winLen: winLen,
        aiMarker: aiMarker,
        humanMarker: humanMarker,
        depth: 0,
        maxDepth: maxDepth,
        isMaximising: false,
        alpha: kScoreLose,
        beta: kScoreWin,
      );
      board[idx] = kEmpty;

      if (score > bestScore) {
        bestScore = score;
        bestMove = idx;
      }
    }
    return bestMove;
  }

  static int _minimax({
    required List<String> board,
    required int size,
    required int winLen,
    required String aiMarker,
    required String humanMarker,
    required int depth,
    required int maxDepth,
    required bool isMaximising,
    required int alpha,
    required int beta,
  }) {
    // Terminal checks
    final result = WinChecker.check(board: board, size: size, winLen: winLen);
    if (result.hasWinner) {
      return result.winner == aiMarker
          ? kScoreWin - depth   // win sooner = higher score
          : kScoreLose + depth; // lose later = less bad
    }
    if (WinChecker.isBoardFull(board) || depth >= maxDepth) {
      return kScoreDraw;
    }

    if (isMaximising) {
      int best = kScoreLose;
      for (final idx in _emptyIndices(board)) {
        board[idx] = aiMarker;
        final score = _minimax(
          board: board, size: size, winLen: winLen,
          aiMarker: aiMarker, humanMarker: humanMarker,
          depth: depth + 1, maxDepth: maxDepth,
          isMaximising: false, alpha: alpha, beta: beta,
        );
        board[idx] = kEmpty;
        best = max(best, score);
        alpha = max(alpha, best);
        if (beta <= alpha) break; // β cut-off
      }
      return best;
    } else {
      int best = kScoreWin;
      for (final idx in _emptyIndices(board)) {
        board[idx] = humanMarker;
        final score = _minimax(
          board: board, size: size, winLen: winLen,
          aiMarker: aiMarker, humanMarker: humanMarker,
          depth: depth + 1, maxDepth: maxDepth,
          isMaximising: true, alpha: alpha, beta: beta,
        );
        board[idx] = kEmpty;
        best = min(best, score);
        beta = min(beta, best);
        if (beta <= alpha) break; // α cut-off
      }
      return best;
    }
  }

  // ================================================================
  // Heuristic search for 4×4 – 7×7
  // ================================================================

  static int _heuristicRoot({
    required List<String> board,
    required int size,
    required int winLen,
    required String aiMarker,
    required String humanMarker,
    required int maxDepth,
  }) {
    int bestScore = kScoreLose - 1;
    int bestMove = _emptyIndices(board).first;

    // Prioritise candidate moves (cells near existing marks) for speed.
    final candidates = _candidateMoves(board, size);

    for (final idx in candidates) {
      board[idx] = aiMarker;
      final score = _alphaBetaHeuristic(
        board: board, size: size, winLen: winLen,
        aiMarker: aiMarker, humanMarker: humanMarker,
        depth: 0, maxDepth: maxDepth,
        isMaximising: false,
        alpha: kScoreLose - 1,
        beta: kScoreWin + 1,
      );
      board[idx] = kEmpty;

      if (score > bestScore) {
        bestScore = score;
        bestMove = idx;
      }
    }
    return bestMove;
  }

  static int _alphaBetaHeuristic({
    required List<String> board,
    required int size,
    required int winLen,
    required String aiMarker,
    required String humanMarker,
    required int depth,
    required int maxDepth,
    required bool isMaximising,
    required int alpha,
    required int beta,
  }) {
    // Terminal / depth-limit checks
    final result = WinChecker.check(board: board, size: size, winLen: winLen);
    if (result.hasWinner) {
      return result.winner == aiMarker
          ? kScoreWin - depth
          : kScoreLose + depth;
    }
    if (WinChecker.isBoardFull(board) || depth >= maxDepth) {
      return _evaluate(
        board: board, size: size, winLen: winLen,
        aiMarker: aiMarker, humanMarker: humanMarker,
      );
    }

    final candidates = _candidateMoves(board, size);

    if (isMaximising) {
      int best = kScoreLose - 1;
      for (final idx in candidates) {
        board[idx] = aiMarker;
        final score = _alphaBetaHeuristic(
          board: board, size: size, winLen: winLen,
          aiMarker: aiMarker, humanMarker: humanMarker,
          depth: depth + 1, maxDepth: maxDepth,
          isMaximising: false, alpha: alpha, beta: beta,
        );
        board[idx] = kEmpty;
        best = max(best, score);
        alpha = max(alpha, best);
        if (beta <= alpha) break;
      }
      return best;
    } else {
      int best = kScoreWin + 1;
      for (final idx in candidates) {
        board[idx] = humanMarker;
        final score = _alphaBetaHeuristic(
          board: board, size: size, winLen: winLen,
          aiMarker: aiMarker, humanMarker: humanMarker,
          depth: depth + 1, maxDepth: maxDepth,
          isMaximising: true, alpha: alpha, beta: beta,
        );
        board[idx] = kEmpty;
        best = min(best, score);
        beta = min(beta, best);
        if (beta <= alpha) break;
      }
      return best;
    }
  }

  // ================================================================
  // Heuristic Evaluation Function
  // ================================================================

  /// Scores the board from the AI's perspective.
  /// Positive = good for AI, negative = bad.
  ///
  /// Scoring table (per matching window):
  ///   winLen-in-a-row (open) → ±100 000 (terminal, handled above)
  ///   (winLen-1)-in-a-row    → ±1 000
  ///   (winLen-2)-in-a-row    → ±100
  ///   1-in-a-row (open)      → ±10
  ///   centre cells           → +5 each
  static int _evaluate({
    required List<String> board,
    required int size,
    required int winLen,
    required String aiMarker,
    required String humanMarker,
  }) {
    int score = 0;

    final weights = {
      winLen - 1: 1000,
      if (winLen > 2) winLen - 2: 100,
      1: 10,
    };

    for (final entry in weights.entries) {
      final len = entry.key;
      final w = entry.value;
      score += WinChecker.countThreats(
            board: board, size: size, winLen: winLen,
            marker: aiMarker, length: len) * w;
      score -= WinChecker.countThreats(
            board: board, size: size, winLen: winLen,
            marker: humanMarker, length: len) * w;
    }

    // Bonus for occupying central cells
    final half = size ~/ 2;
    for (int r = half - 1; r <= half + 1; r++) {
      for (int c = half - 1; c <= half + 1; c++) {
        if (r >= 0 && r < size && c >= 0 && c < size) {
          final cell = board[r * size + c];
          if (cell == aiMarker) score += 5;
          if (cell == humanMarker) score -= 5;
        }
      }
    }

    return score;
  }

  // ================================================================
  // Move ordering helpers
  // ================================================================

  /// Returns candidate move indices: cells within 2 squares of any
  /// occupied cell, falling back to all empty cells if the board is
  /// empty.  Sorted by proximity to centre for better pruning.
  static List<int> _candidateMoves(List<String> board, int size) {
    final occupied = <int>{};
    for (int i = 0; i < board.length; i++) {
      if (board[i] != kEmpty) occupied.add(i);
    }

    if (occupied.isEmpty) {
      // First move → return centre cell only
      final centre = (size ~/ 2) * size + (size ~/ 2);
      return [centre];
    }

    final candidates = <int>{};
    for (final idx in occupied) {
      final r = idx ~/ size;
      final c = idx % size;
      for (int dr = -2; dr <= 2; dr++) {
        for (int dc = -2; dc <= 2; dc++) {
          final nr = r + dr;
          final nc = c + dc;
          if (nr >= 0 && nr < size && nc >= 0 && nc < size) {
            final ni = nr * size + nc;
            if (board[ni] == kEmpty) candidates.add(ni);
          }
        }
      }
    }

    // Sort by distance from centre for better alpha-beta cut-offs
    final centreR = size / 2;
    final centreC = size / 2;
    final sorted = candidates.toList()
      ..sort((a, b) {
        final ar = a ~/ size - centreR;
        final ac = a % size - centreC;
        final br = b ~/ size - centreR;
        final bc = b % size - centreC;
        return (ar * ar + ac * ac).compareTo(br * br + bc * bc);
      });
    return sorted;
  }

  /// Returns all empty cell indices.
  static List<int> _emptyIndices(List<String> board) => [
        for (int i = 0; i < board.length; i++)
          if (board[i] == kEmpty) i,
      ];
}
