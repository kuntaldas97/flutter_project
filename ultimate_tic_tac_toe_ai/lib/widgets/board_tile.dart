// ============================================================
// board_tile.dart
// Individual animated cell widget for the game board.
//
// Features:
//   • Scale-in animation when a marker is placed
//   • Win-highlight pulse animation
//   • Tap ripple via InkWell
//   • Responsive sizing
// ============================================================

import 'package:flutter/material.dart';
import '../utils/theme.dart';

class BoardTile extends StatefulWidget {
  final String marker;        // '', 'X', or 'O'
  final bool isWinning;       // highlight this cell
  final bool isEnabled;       // accept taps
  final VoidCallback onTap;

  const BoardTile({
    super.key,
    required this.marker,
    required this.onTap,
    this.isWinning = false,
    this.isEnabled = true,
  });

  @override
  State<BoardTile> createState() => _BoardTileState();
}

class _BoardTileState extends State<BoardTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  String _prevMarker = '';

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    if (widget.marker.isNotEmpty) _ctrl.value = 1.0;
  }

  @override
  void didUpdateWidget(BoardTile old) {
    super.didUpdateWidget(old);
    // Trigger scale-in when marker changes from empty to filled.
    if (widget.marker.isNotEmpty && _prevMarker.isEmpty) {
      _ctrl.forward(from: 0);
    }
    _prevMarker = widget.marker;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final Color tileColor = widget.isWinning ? kWinHighlight.withOpacity(0.25) : kTileBg;
    final Color borderColor = widget.isWinning ? kWinHighlight : kDivider;

    return GestureDetector(
      onTap: widget.isEnabled && widget.marker.isEmpty ? widget.onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: widget.isWinning ? 2 : 1),
          boxShadow: widget.isWinning
              ? [
                  BoxShadow(
                    color: kWinHighlight.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Center(
          child: widget.marker.isEmpty
              ? const SizedBox.shrink()
              : ScaleTransition(
                  scale: _scale,
                  child: _MarkerText(marker: widget.marker),
                ),
        ),
      ),
    );
  }
}

/// Text widget for the X / O marker with appropriate styling.
class _MarkerText extends StatelessWidget {
  final String marker;
  const _MarkerText({required this.marker});

  @override
  Widget build(BuildContext context) {
    final color = markerColor(marker);
    return Text(
      marker,
      style: TextStyle(
        color: color,
        fontSize: _fontSize(context),
        fontWeight: FontWeight.w800,
        shadows: [
          Shadow(
            color: color.withOpacity(0.6),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }

  double _fontSize(BuildContext context) {
    final size = MediaQuery.of(context).size.shortestSide;
    // Scale font relative to screen: works for 3×3 up to 7×7
    return size * 0.07;
  }
}
