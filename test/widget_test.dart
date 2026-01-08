// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hamzahhhhh/main.dart';

void main() {
  testWidgets('App launches and shows splash screen', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const YemenMarketApp());

    // Verify that the splash screen appears with the app name
    expect(find.text('حمزه الشامي'), findsOneWidget);
    expect(find.text('مخزن النخبة'), findsOneWidget);

    // Wait for the splash screen duration (2 seconds)
    await tester.pump(const Duration(seconds: 2));

    // After splash screen, should navigate to login screen
    // The login screen should contain login form elements
    expect(find.text('تسجيل الدخول'), findsOneWidget);
  });
}
