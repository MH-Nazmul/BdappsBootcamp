// Unit tests that don't require a live Firebase connection.
//
// The CRUD flow itself is exercised against a real Firestore project when you
// run the app (see the README). These tests cover the pure Dart pieces.

import 'package:flutter_test/flutter_test.dart';

import 'package:notes_firestore/models/note.dart';
import 'package:notes_firestore/screens/add_edit_note_screen.dart';

void main() {
  test('Note holds the values it is created with', () {
    const note = Note(id: 'abc', title: 'Shopping', description: 'Milk, eggs');

    expect(note.id, 'abc');
    expect(note.title, 'Shopping');
    expect(note.description, 'Milk, eggs');
  });

  test('AddEditNoteScreen is in create mode when no note is passed', () {
    const screen = AddEditNoteScreen();
    expect(screen.isEditing, isFalse);
  });

  test('AddEditNoteScreen is in edit mode when a note is passed', () {
    const note = Note(id: 'abc', title: 'Title', description: 'Body');
    const screen = AddEditNoteScreen(note: note);
    expect(screen.isEditing, isTrue);
  });
}
