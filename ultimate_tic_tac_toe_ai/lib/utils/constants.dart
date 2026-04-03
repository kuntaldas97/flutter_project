// ============================================================
// constants.dart
// Central constants for the Ultimate Tic Tac Toe AI game.
// All magic numbers and configuration live here.
// ============================================================

/// Supported board sizes for the game.
const List<int> kBoardSizes = [3, 4, 5, 6, 7];

/// Default board size when the app launches.
const int kDefaultBoardSize = 3;

/// Maps each board size to the required consecutive marks to win.
/// 3×3 → 3-in-a-row, 4×4 → 4-in-a-row, 5×5 → 4-in-a-row,
/// 6×6 → 5-in-a-row, 7×7 → 5-in-a-row.
const Map<int, int> kWinLength = {
  3: 3,
  4: 4,
  5: 4,
  6: 5,
  7: 5,
};

/// Player marker strings displayed on the board.
const String kPlayerX = 'X';
const String kPlayerO = 'O';
const String kEmpty = '';

/// AI difficulty labels.
const String kEasy = 'Easy';
const String kMedium = 'Medium';
const String kHard = 'Hard';
const List<String> kDifficultyLevels = [kEasy, kMedium, kHard];

/// Game mode labels.
const String kModePlayerVsAI = 'Player vs AI';
const String kModePlayerVsPlayer = 'Player vs Player';
const List<String> kGameModes = [kModePlayerVsAI, kModePlayerVsPlayer];

/// Minimax search depth limits per difficulty.
/// Higher = stronger AI, but more CPU time.
const Map<String, int> kDepthLimit = {
  kEasy: 1,
  kMedium: 3,
  kHard: 9, // Effectively unlimited for 3×3; capped by board size for larger.
};

/// Heuristic score constants for AI evaluation.
const int kScoreWin = 100000;
const int kScoreLose = -100000;
const int kScoreDraw = 0;

/// Animation duration for tile flip (milliseconds).
const int kTileAnimationMs = 300;

/// App metadata.
const String kAppName = 'Ultimate Tic Tac Toe AI';
const String kAppVersion = '1.0.0';
