// ============================================================
// game_state.dart
// Immutable snapshot of the entire game at a point in time.
// GameController derives a new GameState on every move.
// ============================================================

import '../models/player.dart';
import '../utils/constants.dart';

/// Describes the current phase of the game.
enum GameStatus {
  idle,       // Not started yet
  playing,    // In progress
  won,        // A player has won
  draw,       // Board full, no winner
}

/// Immutable snapshot of the board and score state.
class GameState {
  /// Flat 1-D list of length [size*size].
  /// Cell value: '' (empty), 'X', or 'O'.
  final List<String> board;

  /// Grid dimension (3–7).
  final int size;

  /// The player whose turn it is.
  final Player currentPlayer;

  /// Both players.
  final Player playerX;
  final Player playerO;

  /// Current game phase.
  final GameStatus status;

  /// Indices of the winning cells (empty if no winner yet).
  final List<int> winningCells;

  /// Cumulative scores across multiple rounds.
  final int scoreX;
  final int scoreO;
  final int scoreDraw;

  /// Selected difficulty (only relevant in PvAI mode).
  final String difficulty;

  /// Selected game mode.
  final String gameMode;

  const GameState({
    required this.board,
    required this.size,
    required this.currentPlayer,
    required this.playerX,
    required this.playerO,
    this.status = GameStatus.playing,
    this.winningCells = const [],
    this.scoreX = 0,
    this.scoreO = 0,
    this.scoreDraw = 0,
    this.difficulty = kHard,
    this.gameMode = kModePlayerVsAI,
  });

  /// Convenient factory to start a fresh game.
  factory GameState.initial({
    int size = kDefaultBoardSize,
    String difficulty = kHard,
    String gameMode = kModePlayerVsAI,
    int scoreX = 0,
    int scoreO = 0,
    int scoreDraw = 0,
  }) {
    final px = const Player(name: 'Player', side: PlayerSide.x);
    final po = Player(
      name: gameMode == kModePlayerVsAI ? 'AI' : 'Player 2',
      side: PlayerSide.o,
      isAI: gameMode == kModePlayerVsAI,
    );
    return GameState(
      board: List.filled(size * size, kEmpty),
      size: size,
      currentPlayer: px,
      playerX: px,
      playerO: po,
      status: GameStatus.playing,
      winningCells: const [],
      scoreX: scoreX,
      scoreO: scoreO,
      scoreDraw: scoreDraw,
      difficulty: difficulty,
      gameMode: gameMode,
    );
  }

  // --------------- Derived helpers ---------------

  /// True if the cell at [index] is unoccupied.
  bool isCellEmpty(int index) => board[index] == kEmpty;

  /// True when it's the AI's turn.
  bool get isAITurn =>
      currentPlayer.isAI && status == GameStatus.playing;

  /// Number of marks placed (used for draw detection shortcut).
  int get moveCount => board.where((c) => c != kEmpty).length;

  // --------------- Immutable copy ---------------

  GameState copyWith({
    List<String>? board,
    int? size,
    Player? currentPlayer,
    Player? playerX,
    Player? playerO,
    GameStatus? status,
    List<int>? winningCells,
    int? scoreX,
    int? scoreO,
    int? scoreDraw,
    String? difficulty,
    String? gameMode,
  }) {
    return GameState(
      board: board ?? List.from(this.board),
      size: size ?? this.size,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      playerX: playerX ?? this.playerX,
      playerO: playerO ?? this.playerO,
      status: status ?? this.status,
      winningCells: winningCells ?? List.from(this.winningCells),
      scoreX: scoreX ?? this.scoreX,
      scoreO: scoreO ?? this.scoreO,
      scoreDraw: scoreDraw ?? this.scoreDraw,
      difficulty: difficulty ?? this.difficulty,
      gameMode: gameMode ?? this.gameMode,
    );
  }

  @override
  String toString() =>
      'GameState(size=$size, status=$status, move=${currentPlayer.marker})';
}
