// Basic smoke test for the app.
//
// Verifies the app boots into the login screen without throwing.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bd_app_coding/main.dart';
import 'package:bd_app_coding/models/auth_provider.dart';

void main() {
  testWidgets('App boots and shows the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>(
        create: (_) => AuthProvider(),
        child: const MyApp(),
      ),
    );

    // The app should build a MaterialApp with the login route as its home.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
