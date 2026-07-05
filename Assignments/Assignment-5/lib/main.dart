import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/navigation_provider.dart';
import 'providers/subject_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_scaffold.dart';
import 'theme/app_themes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubjectProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: const GradeTrackerApp(),
    ),
  );
}

class GradeTrackerApp extends StatelessWidget {
  const GradeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;

    return MaterialApp(
      title: 'Student Grade Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeMode,
      home: const HomeScaffold(),
    );
  }
}
