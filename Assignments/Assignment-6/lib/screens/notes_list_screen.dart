import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/note_service.dart';
import 'add_edit_note_screen.dart';

/// The main screen — shows every note from Firestore in a live list.
class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteService = NoteService();

    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')),
      body: StreamBuilder<List<Note>>(
        stream: noteService.watchNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _CenteredMessage(
              icon: Icons.error_outline,
              text: 'Something went wrong.\n${snapshot.error}',
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data ?? const [];
          if (notes.isEmpty) {
            return const _CenteredMessage(
              icon: Icons.note_add_outlined,
              text: 'No notes yet.\nTap + to create your first note.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: notes.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: note.description.isEmpty
                    ? null
                    : Text(
                        note.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                onTap: () => _openEditor(context, note: note),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete note',
                  onPressed: () => _confirmDelete(context, noteService, note),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context),
        tooltip: 'Add note',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openEditor(BuildContext context, {Note? note}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddEditNoteScreen(note: note)),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    NoteService service,
    Note note,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete note?'),
        content: Text('"${note.title}" will be permanently removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await service.deleteNote(note.id);
    }
  }
}

class _CenteredMessage extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CenteredMessage({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: scheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
