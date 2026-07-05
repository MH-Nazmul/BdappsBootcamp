import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note.dart';

/// All Cloud Firestore CRUD operations for notes live here.
///
/// Notes are stored in the dedicated top-level `notesApp` collection. Using an
/// app-specific collection keeps this app's data isolated from anything else in
/// the same Firebase project, so both the data and its security rule can be
/// removed later without touching other collections. Each document holds a
/// `title`, a `description` and an `updatedAt` server timestamp used to order
/// the list (most recently changed first).
class NoteService {
  /// The one collection this app is allowed to touch. Keep this in sync with
  /// the Firestore security rule (`match /notesApp/{noteId}`).
  static const String collectionName = 'notesApp';

  final CollectionReference<Map<String, dynamic>> _notes =
      FirebaseFirestore.instance.collection(collectionName);

  /// READ — a live stream of all notes, newest first.
  Stream<List<Note>> watchNotes() {
    return _notes
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Note.fromDoc).toList());
  }

  /// CREATE — add a new note.
  Future<void> addNote({
    required String title,
    required String description,
  }) {
    return _notes.add({
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// UPDATE — edit an existing note.
  Future<void> updateNote({
    required String id,
    required String title,
    required String description,
  }) {
    return _notes.doc(id).update({
      'title': title,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// DELETE — remove a note.
  Future<void> deleteNote(String id) {
    return _notes.doc(id).delete();
  }
}
