// ============================================================
// win_checker.dart
// Stateless utility for win / draw detection on any NxN board.
//
// Strategy
// --------
// For every cell that holds a non-empty marker we scan the four
// directions (→, ↓, ↘, ↙) and count consecutive matches.
// We only scan from each "start" cell once per direction so the
// overall complexity stays at O(n²·winLen) — fast enough even
// for a 7×7 board.
// ============================================================

import '../utils/constants.dart';

/// Holds the result of a win-check scan.
class WinResult {
  /// True when a winner was found.
  final bool hasWinner;

  /// The winning marker ('X' or 'O'), empty string if none.
  final String winner;

  /// Flat board indices that form the winning line.
  final List<int> winningCells;

  const WinResult({
    required this.hasWinner,
    required this.winner,
    required this.winningCells,
  });

  /// Convenience constant for "no winner".
  static const WinResult none = WinResult(
    hasWinner: false,
    winner: '',
    winningCells: [],
  );
}

class WinChecker {
  WinChecker._(); // purely static – never instantiated

  // --------------- Public API ---------------

  /// Checks the [board] of dimension [size]×[size] for a winner.
  /// [winLen] is the consecutive-marks target (from [kWinLength]).
  /// Returns a [WinResult] describing the outcome.
  static WinResult check({
    required List<String> board,
    required int size,
    required int winLen,
  }) {
    // The four scan directions: (dRow, dCol)
    const dirs = [
      (0, 1),   // horizontal  →
      (1, 0),   // vertical    ↓
      (1, 1),   // diagonal    ↘
      (1, -1),  // anti-diag   ↙
    ];

    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        final marker = board[r * size + c];
        if (marker == kEmpty) continue;

        for (final (dr, dc) in dirs) {
          final cells = _scanLine(
            board: board,
            size: size,
            startR: r,
            startC: c,
            dr: dr,
            dc: dc,
            marker: marker,
            winLen: winLen,
          );
          if (cells != null) {
            return WinResult(
              hasWinner: true,
              winner: marker,
              winningCells: cells,
            );
          }
        }
      }
    }
    return WinResult.none;
  }

  /// Returns true when every cell is filled (used for draw detection).
  static bool isBoardFull(List<String> board) =>
      board.every((cell) => cell != kEmpty);

  // --------------- Private helpers ---------------

  /// Scans [winLen] cells from (startR, startC) in direction (dr, dc).
  /// Returns the list of flat indices if all cells match [marker], else null.
  static List<int>? _scanLine({
    required List<String> board,
    required int size,
    required int startR,
    required int startC,
    required int dr,
    required int dc,
    required String marker,
    required int winLen,
  }) {
    final cells = <int>[];
    for (int step = 0; step < winLen; step++) {
      final r = startR + dr * step;
      final c = startC + dc * step;
      if (r < 0 || r >= size || c < 0 || c >= size) return null;
      final idx = r * size + c;
      if (board[idx] != marker) return null;
      cells.add(idx);
    }
    return cells;
  }

  // --------------- Heuristic helpers (used by AI) ---------------

  /// Counts how many lines of exactly [length] same [marker] exist,
  /// with the remaining cells in those lines being empty.
  /// Used to score board positions during heuristic evaluation.
  static int countThreats({
    required List<String> board,
    required int size,
    required int winLen,
    required String marker,
    required int length,
  }) {
    int count = 0;
    const dirs = [(0, 1), (1, 0), (1, 1), (1, -1)];

    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        for (final (dr, dc) in dirs) {
          int markerCount = 0;
          int emptyCount = 0;
          bool blocked = false;

          for (int step = 0; step < winLen; step++) {
            final nr = r + dr * step;
            final nc = c + dc * step;
            if (nr < 0 || nr >= size || nc < 0 || nc >= size) {
              blocked = true;
              break;
            }
            final cell = board[nr * size + nc];
            if (cell == marker) {
              markerCount++;
            } else if (cell == kEmpty) {
              emptyCount++;
            } else {
              blocked = true;
              break;
            }
          }

          if (!blocked && markerCount == length && emptyCount == winLen - length) {
            count++;
          }
        }
      }
    }
    return count;
  }
}
