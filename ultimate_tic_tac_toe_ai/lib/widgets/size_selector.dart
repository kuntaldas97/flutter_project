// ============================================================
// size_selector.dart
// Horizontal chip-row for selecting board size (3–7).
// ============================================================

import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';

class SizeSelector extends StatelessWidget {
  final int selectedSize;
  final ValueChanged<int> onSizeChanged;

  const SizeSelector({
    super.key,
    required this.selectedSize,
    required this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text('Board Size',
              style: TextStyle(
                  color: kTextSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
        ),
        Row(
          children: kBoardSizes.map((size) {
            final selected = size == selectedSize;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSizeChanged(size),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selected ? kPrimary : kTileBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected ? kPrimary : kDivider,
                      width: 1.5,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: kPrimary.withOpacity(0.4),
                              blurRadius: 8,
                            )
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$size×$size',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selected ? Colors.white : kTextSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${kWinLength[size]}-in-row',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selected
                              ? Colors.white70
                              : kTextSecondary.withOpacity(0.6),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
