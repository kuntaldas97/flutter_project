// ============================================================
// score_board.dart
// Persistent score display showing X wins, draws, and O wins.
// ============================================================

import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ScoreBoard extends StatelessWidget {
  final String labelX;
  final String labelO;
  final int scoreX;
  final int scoreO;
  final int scoreDraw;

  const ScoreBoard({
    super.key,
    required this.labelX,
    required this.labelO,
    required this.scoreX,
    required this.scoreO,
    required this.scoreDraw,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: cardDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ScoreCell(
            label: labelX,
            marker: 'X',
            score: scoreX,
            color: kPlayerXColor,
          ),
          _Divider(),
          _ScoreCell(
            label: 'Draw',
            marker: '—',
            score: scoreDraw,
            color: kTextSecondary,
          ),
          _Divider(),
          _ScoreCell(
            label: labelO,
            marker: 'O',
            score: scoreO,
            color: kPlayerOColor,
          ),
        ],
      ),
    );
  }
}

class _ScoreCell extends StatelessWidget {
  final String label;
  final String marker;
  final int score;
  final Color color;

  const _ScoreCell({
    required this.label,
    required this.marker,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          marker,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          score.toString(),
          style: TextStyle(
            color: color,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: kTextSecondary, fontSize: 11),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 1,
      color: kDivider,
    );
  }
}
