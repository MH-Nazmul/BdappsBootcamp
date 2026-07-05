import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/subject_provider.dart';
import '../widgets/grade_badge.dart';

/// Screen 3 — a live summary that updates whenever subjects change.
class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watching the provider makes this whole screen rebuild live as subjects
    // are added or removed on the other tabs.
    final provider = context.watch<SubjectProvider>();
    final hasSubjects = provider.totalSubjects > 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StatCard(
            icon: Icons.menu_book_outlined,
            label: 'Total subjects',
            value: '${provider.totalSubjects}',
          ),
          _StatCard(
            icon: Icons.percent_outlined,
            label: 'Average mark',
            value: hasSubjects ? provider.averageMark.toStringAsFixed(1) : '—',
          ),
          _StatCard(
            icon: Icons.verified_outlined,
            label: 'Passing subjects',
            value: '${provider.passingSubjects.length} / ${provider.totalSubjects}',
          ),
          const SizedBox(height: 8),
          _OverallGradeCard(grade: provider.overallGrade),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: scheme.primary),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: textTheme.titleMedium)),
            Text(
              value,
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverallGradeCard extends StatelessWidget {
  final String grade;

  const _OverallGradeCard({required this.grade});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall grade', style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Based on the average of all marks',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            GradeBadge(grade: grade, size: 64),
          ],
        ),
      ),
    );
  }
}
