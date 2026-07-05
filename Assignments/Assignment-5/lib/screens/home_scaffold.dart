import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';
import '../providers/theme_provider.dart';
import 'add_subject_screen.dart';
import 'subject_list_screen.dart';
import 'summary_screen.dart';

/// The single Scaffold that hosts the three screens, the BottomNavigationBar
/// and the light/dark theme toggle in the AppBar.
class HomeScaffold extends StatelessWidget {
  const HomeScaffold({super.key});

  static const _titles = ['Add Subject', 'Subjects', 'Summary'];

  static const _screens = [
    AddSubjectScreen(),
    SubjectListScreen(),
    SummaryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigation = context.watch<NavigationProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[navigation.index]),
        actions: [
          IconButton(
            tooltip: themeProvider.isDark
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            icon: Icon(
              themeProvider.isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
        ],
      ),
      // IndexedStack keeps each screen alive so the form keeps its input while
      // the user hops between tabs.
      body: IndexedStack(
        index: navigation.index,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigation.index,
        onTap: (index) => context.read<NavigationProvider>().setIndex(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Summary',
          ),
        ],
      ),
    );
  }
}
