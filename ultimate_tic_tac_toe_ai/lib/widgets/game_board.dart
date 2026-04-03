// ============================================================
// game_board.dart
// Renders the NxN grid using a GridView, delegating individual
// cells to BoardTile.
// ============================================================

import 'package:flutter/material.dart';
import 'board_tile.dart';

class GameBoard extends StatelessWidget {
  final List<String> board;
  final int size;
  final List<int> winningCells;
  final bool isEnabled;
  final void Function(int index) onTileTapped;

  const GameBoard({
    super.key,
    required this.board,
    required this.size,
    required this.onTileTapped,
    this.winningCells = const [],
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // Keep the board square and respect safe-area / appbar.
    final availableWidth = MediaQuery.of(context).size.width - 32;
    final boardSize = availableWidth.clamp(200.0, 440.0);
    final gap = size <= 4 ? 8.0 : 5.0;

    return SizedBox(
      width: boardSize,
      height: boardSize,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: size,
          mainAxisSpacing: gap,
          crossAxisSpacing: gap,
        ),
        itemCount: size * size,
        itemBuilder: (_, index) {
          return BoardTile(
            marker: board[index],
            isWinning: winningCells.contains(index),
            isEnabled: isEnabled,
            onTap: () => onTileTapped(index),
          );
        },
      ),
    );
  }
}
