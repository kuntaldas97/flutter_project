// ============================================================
// settings_screen.dart
// App-level settings: theme info, about, and credits.
// (Expandable – add sound toggle, haptics, etc. here.)
// ============================================================

import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── About card ────────────────────────────────────────
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('✕○',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(kAppName,
                            style: TextStyle(
                                color: kTextPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                        Text('Version $kAppVersion',
                            style: TextStyle(color: kTextSecondary, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: kDivider),
                const SizedBox(height: 8),
                const Text(
                  'A modern Tic Tac Toe experience with a powerful AI opponent, '
                  'dynamic board sizes from 3×3 to 7×7, and adaptive win conditions.',
                  style: TextStyle(color: kTextSecondary, fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── AI info ──────────────────────────────────────────
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('AI Algorithms',
                    style: TextStyle(
                        color: kTextPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.grid_3x3,
                  title: '3×3 Board',
                  subtitle: 'Minimax + Alpha-Beta pruning (optimal)',
                ),
                _InfoRow(
                  icon: Icons.grid_4x4,
                  title: '4×4 – 7×7 Boards',
                  subtitle: 'Heuristic evaluation with depth-limited search',
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Win conditions ───────────────────────────────────
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Win Conditions',
                    style: TextStyle(
                        color: kTextPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                const SizedBox(height: 8),
                for (final entry in kWinLength.entries)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: kPrimary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${entry.key}×${entry.key}',
                            style: const TextStyle(
                                color: kPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${entry.value} in a row to win',
                          style: const TextStyle(
                              color: kTextSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration(),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: kPrimary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: kTextPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                Text(subtitle,
                    style: const TextStyle(
                        color: kTextSecondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
