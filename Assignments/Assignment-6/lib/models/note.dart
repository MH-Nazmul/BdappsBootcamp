import 'package:cloud_firestore/cloud_firestore.dart';

/// A single note stored in Cloud Firestore.
///
/// Each note has a Firestore document [id], a [title] and a [description].
class Note {
  final String id;
  final String title;
  final String description;

  const Note({
    required this.id,
    required this.title,
    required this.description,
  });

  /// Builds a [Note] from a Firestore document snapshot.
  factory Note.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    return Note(
      id: doc.id,
      title: (data['title'] ?? '') as String,
      description: (data['description'] ?? '') as String,
    );
  }
}
