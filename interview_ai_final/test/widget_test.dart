// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:interviewai/main.dart';

void main() {
  testWidgets('Application starts without crashing', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const InterviewApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Verify that the widget tree contains the app root.
    expect(find.byType(InterviewApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
