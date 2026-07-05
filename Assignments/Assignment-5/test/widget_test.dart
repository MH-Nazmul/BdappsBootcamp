// Unit + smoke tests for the Student Grade Tracker app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:student_grade_tracker/main.dart';
import 'package:student_grade_tracker/models/subject.dart';
import 'package:student_grade_tracker/providers/navigation_provider.dart';
import 'package:student_grade_tracker/providers/subject_provider.dart';
import 'package:student_grade_tracker/providers/theme_provider.dart';

void main() {
  group('Subject grade getter', () {
    test('returns the correct letter grade for each band', () {
      expect(Subject(name: 'Math', mark: 90).grade, 'A');
      expect(Subject(name: 'Physics', mark: 70).grade, 'B');
      expect(Subject(name: 'Chemistry', mark: 55).grade, 'C');
      expect(Subject(name: 'Biology', mark: 30).grade, 'F');
    });

    test('marks the failing subject as not passing', () {
      expect(Subject(name: 'History', mark: 49).isPassing, isFalse);
      expect(Subject(name: 'Art', mark: 50).isPassing, isTrue);
    });
  });

  group('SubjectProvider summary', () {
    test('computes average, overall grade and passing count', () {
      final provider = SubjectProvider();
      provider.addSubject(Subject(name: 'Math', mark: 80));
      provider.addSubject(Subject(name: 'English', mark: 40));

      expect(provider.totalSubjects, 2);
      expect(provider.averageMark, 60);
      expect(provider.overallGrade, 'C');
      expect(provider.passingSubjects.length, 1);
    });
  });

  testWidgets('App builds and shows the first tab', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SubjectProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ],
        child: const GradeTrackerApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Add Subject'), findsWidgets);
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
  });
}
