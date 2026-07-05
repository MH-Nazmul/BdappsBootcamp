# Notes Management App (Flutter + Cloud Firestore)

A simple notes app that stores its data in **Cloud Firestore**. You can create,
read, update and delete notes — a full CRUD example of a Flutter app talking to
Firebase.

> Module 6 Assignment — BdApps Bootcamp

---

## Features

Each note has a **title** and a **description**, and the app supports every CRUD
operation:

- **Create** — add a new note from the Add screen (`+` button).
- **Read** — all notes are shown in a live list that updates in real time as the
  Firestore data changes (`StreamBuilder`).
- **Update** — tap a note to open it in the editor and save changes.
- **Delete** — tap the trash icon and confirm to remove a note.

### Screens

1. **Notes List** — displays all notes stored in Firestore.
2. **Add / Edit Note** — one screen used both to create a new note and to edit
   an existing one.

---

## Firebase setup (required before running)

This project ships with a **placeholder** `lib/firebase_options.dart`. You must
connect it to your own Firebase project first.

1. **Create a Firebase project** at <https://console.firebase.google.com>.

2. **Enable Cloud Firestore**: in the console go to
   *Build → Firestore Database → Create database*. Start in **test mode** for
   development (or use the rules below).

3. **Install the CLIs** (once per machine):

   ```bash
   npm install -g firebase-tools
   firebase login
   dart pub global activate flutterfire_cli
   ```

4. **Configure the app** from the project root. This overwrites the placeholder
   `lib/firebase_options.dart` with your real project settings and adds the
   native config files (e.g. `google-services.json`):

   ```bash
   flutterfire configure
   ```

5. **Firestore security rules** — this app only ever touches its own
   `notesApp` collection, so its rule is a single self-contained block. Add it
   inside your existing ruleset (a Firestore database has one shared ruleset).
   Any collection without a matching rule stays denied by default, so nothing
   else in the project is exposed:

   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {

       // ===== Notes App (Module 6) — START =====
       // Isolated rules for this app. Exposes ONLY the notesApp collection.
       // To remove this app later: delete this block AND the notesApp collection.
       match /notesApp/{noteId} {
         allow read, write: if true; // open access — fine for a demo, not production
       }
       // ===== Notes App (Module 6) — END =====

     }
   }
   ```

---

## How to run

```bash
# 1. Get the packages
flutter pub get

# 2. Configure Firebase (see the section above) — only needed once
flutterfire configure

# 3. Run the app
flutter run
```

Run the unit tests (these do not need Firebase) with:

```bash
flutter test
```

Requires the Flutter SDK (developed on Flutter 3.44 / Dart 3.12).

---

## Data model

Notes are stored in a dedicated top-level Firestore collection called
**`notesApp`** (app-specific so it stays isolated and easy to delete later).
Each document looks like:

| Field         | Type      | Notes                                  |
| ------------- | --------- | -------------------------------------- |
| `title`       | string    | Note title                             |
| `description` | string    | Note body                              |
| `createdAt`   | timestamp | Server timestamp set on create         |
| `updatedAt`   | timestamp | Server timestamp; used to sort newest first |

---

## Project structure

```
lib/
├── main.dart                       # Initializes Firebase, launches the app
├── firebase_options.dart           # Firebase config (regenerate with flutterfire configure)
├── models/
│   └── note.dart                   # Note model + fromDoc() mapping
├── services/
│   └── note_service.dart           # Firestore CRUD (create / read / update / delete)
└── screens/
    ├── notes_list_screen.dart      # Live list of notes (StreamBuilder) + delete
    └── add_edit_note_screen.dart   # Create / edit form
```

---

## How each requirement is met

- **Create** — `NoteService.addNote()` writes a new document to `notes`.
- **View** — `NoteService.watchNotes()` streams the collection and the list
  screen renders it with a `StreamBuilder`.
- **Update** — `NoteService.updateNote()` edits an existing document; the editor
  screen is reused with the selected note pre-filled.
- **Delete** — `NoteService.deleteNote()` removes a document after a confirm
  dialog.
