import 'package:flutter/foundation.dart';

import '../models/subject.dart';

/// Holds the list of subjects and exposes the derived summary values.
///
/// Every mutation calls [notifyListeners] so any widget that watches this
/// provider (the list and the summary) rebuilds automatically — no setState.
class SubjectProvider extends ChangeNotifier {
  final List<Subject> _subjects = [];

  /// Unmodifiable view so widgets can read but never mutate the list directly.
  List<Subject> get subjects => List.unmodifiable(_subjects);

  int get totalSubjects => _subjects.length;

  /// Uses .where() to keep only the passing subjects.
  List<Subject> get passingSubjects =>
      _subjects.where((subject) => subject.isPassing).toList();

  /// Uses .map() to pull out the marks, then averages them.
  double get averageMark {
    if (_subjects.isEmpty) return 0;
    final total = _subjects.map((subject) => subject.mark).reduce((a, b) => a + b);
    return total / _subjects.length;
  }

  /// Overall grade based on the average mark, same scale as [Subject.grade].
  String get overallGrade {
    if (_subjects.isEmpty) return 'N/A';
    final avg = averageMark;
    if (avg >= 80) return 'A';
    if (avg >= 65) return 'B';
    if (avg >= 50) return 'C';
    return 'F';
  }

  void addSubject(Subject subject) {
    _subjects.add(subject);
    notifyListeners();
  }

  void removeSubject(Subject subject) {
    _subjects.remove(subject);
    notifyListeners();
  }
}
