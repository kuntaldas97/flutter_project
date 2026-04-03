// ============================================================
// player.dart
// Immutable data model representing a game participant.
// ============================================================

/// Enum for the two sides in the game.
enum PlayerSide { x, o }

/// Immutable value-object representing a player (human or AI).
class Player {
  final String name;
  final PlayerSide side;
  final bool isAI;

  const Player({
    required this.name,
    required this.side,
    this.isAI = false,
  });

  /// The board marker for this player ('X' or 'O').
  String get marker => side == PlayerSide.x ? 'X' : 'O';

  /// The opponent's marker.
  String get opponentMarker => side == PlayerSide.x ? 'O' : 'X';

  /// Returns a copy with changed fields.
  Player copyWith({String? name, PlayerSide? side, bool? isAI}) {
    return Player(
      name: name ?? this.name,
      side: side ?? this.side,
      isAI: isAI ?? this.isAI,
    );
  }

  @override
  String toString() => 'Player($name, ${marker}, isAI=$isAI)';

  @override
  bool operator ==(Object other) =>
      other is Player && other.side == side && other.isAI == isAI;

  @override
  int get hashCode => Object.hash(side, isAI);
}
