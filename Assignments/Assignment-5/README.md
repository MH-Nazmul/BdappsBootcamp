# Student Grade Tracker

A Flutter app where a student can add subjects with marks, see the grade for
each subject, and view a live result summary. State is managed entirely with
**Provider** — there is **zero `setState`** anywhere in the app.

> Module 5 Assignment — BdApps Bootcamp

---

## What the app does

- **Add Subject** — a validated form to enter a subject name and a mark (0–100).
- **Subjects** — every subject in a `ListView.builder`, showing its name, mark
  and grade. Swipe an item from right to left to delete it (`Dismissible`).
- **Summary** — total subjects, average mark, passing count and the overall
  grade. It updates **live** the moment a subject is added or removed.

You switch between the three screens with a `BottomNavigationBar`, and toggle
between the **light and dark** theme from the icon in the AppBar.

---

## Grading scale

| Mark      | Grade |
| --------- | ----- |
| 80 – 100  | A     |
| 65 – 79   | B     |
| 50 – 64   | C     |
| below 50  | F     |

The same scale is applied to a single subject's mark and to the average mark
(for the overall grade).

---

## How to run

```bash
# 1. Get the packages
flutter pub get

# 2. Run on a connected device / emulator / Chrome
flutter run
```

Run the tests with:

```bash
flutter test
```

Requires the Flutter SDK (developed on Flutter 3.44 / Dart 3.12).

---

## Project structure

```
lib/
├── main.dart                        # MultiProvider + MaterialApp (light/dark themes)
├── models/
│   └── subject.dart                 # Subject class: private _mark field + grade getter
├── providers/
│   ├── subject_provider.dart        # List<Subject>, average, passing (.where/.map)
│   ├── theme_provider.dart          # light / dark ThemeMode
│   └── navigation_provider.dart     # selected bottom-nav tab
├── theme/
│   └── app_themes.dart              # custom light & dark ThemeData
├── widgets/
│   └── grade_badge.dart             # grade badge coloured from the ColorScheme
└── screens/
    ├── home_scaffold.dart           # BottomNavigationBar + AppBar theme toggle
    ├── add_subject_screen.dart      # Screen 1 — validated form
    ├── subject_list_screen.dart     # Screen 2 — ListView.builder + Dismissible
    └── summary_screen.dart          # Screen 3 — live summary
```

---

## How each requirement is met

- **`Subject` class** — has a public `name` and a private `_mark` field, exposed
  read-only through a `mark` getter, plus a `grade` getter. *(`models/subject.dart`)*
- **`.map()` / `.where()`** — `passingSubjects` uses `.where()` and `averageMark`
  uses `.map()`. *(`providers/subject_provider.dart`)*
- **Form validation** — the name must not be empty and the mark must be a whole
  number between 0 and 100. *(`screens/add_subject_screen.dart`)*
- **`ListView.builder` + `Dismissible`** — the list is built lazily and each row
  is dismissible to delete. *(`screens/subject_list_screen.dart`)*
- **Live summary** — the summary watches the provider, so it recomputes whenever
  a subject is added or removed. *(`screens/summary_screen.dart`)*
- **Custom light & dark themes** — both themes are built from custom `ThemeData`;
  every widget reads its colors from `Theme.of(context)`. The only color literal
  in the whole app is the palette seed in `theme/app_themes.dart`.
- **Provider only, no `setState`** — all state lives in three `ChangeNotifier`
  providers; there is not a single `setState` call in the app.
