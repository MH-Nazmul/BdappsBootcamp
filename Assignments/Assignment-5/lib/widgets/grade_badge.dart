import 'package:flutter/material.dart';

/// A small circular badge showing a letter grade.
///
/// The colors are picked from the active [ColorScheme] roles, so the badge
/// looks correct in both light and dark themes with no hardcoded colors.
class GradeBadge extends StatelessWidget {
  final String grade;
  final double size;

  const GradeBadge({super.key, required this.grade, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (Color background, Color foreground) = switch (grade) {
      'A' => (scheme.primary, scheme.onPrimary),
      'B' => (scheme.tertiary, scheme.onTertiary),
      'C' => (scheme.secondary, scheme.onSecondary),
      _ => (scheme.error, scheme.onError),
    };

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Text(
        grade,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.4,
        ),
      ),
    );
  }
}
