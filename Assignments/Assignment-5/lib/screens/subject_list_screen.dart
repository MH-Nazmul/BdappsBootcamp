import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/subject_provider.dart';
import '../widgets/grade_badge.dart';

/// Screen 2 — lists every subject and lets the user swipe to delete.
class SubjectListScreen extends StatelessWidget {
  const SubjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = context.watch<SubjectProvider>().subjects;
    final scheme = Theme.of(context).colorScheme;

    if (subjects.isEmpty) {
      return _EmptyMessage(
        icon: Icons.inbox_outlined,
        text: 'No subjects yet.\nAdd one from the "Add" tab.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];

        return Dismissible(
          key: ObjectKey(subject),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: scheme.errorContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.delete_outline, color: scheme.onErrorContainer),
          ),
          onDismissed: (_) {
            context.read<SubjectProvider>().removeSubject(subject);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('"${subject.name}" removed')),
            );
          },
          child: Card(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: GradeBadge(grade: subject.grade),
              title: Text(
                subject.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('Mark: ${subject.mark}'),
              trailing: Text(
                'Grade ${subject.grade}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EmptyMessage({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: scheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
