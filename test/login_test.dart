import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:emergency_app/login_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('validates required fields', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.pump();

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Please enter your email address'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('rejects an invalid email format', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.pump();

    await tester.enterText(find.byType(TextFormField).first, 'not-an-email');
    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Please enter a valid email address'), findsOneWidget);
  });

  testWidgets('password visibility toggle switches icons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.pump();

    expect(find.byIcon(Icons.visibility_off_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off_rounded));
    await tester.pump();

    expect(find.byIcon(Icons.visibility_rounded), findsOneWidget);
  });

  testWidgets('successful login opens the home page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.pump();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'farmer@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'secret123');

    await tester.tap(find.text('Login'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Healthy Crops, Brighter Tomorrow'), findsOneWidget);
  });

  testWidgets('sign up link opens the registration page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.pump();

    await tester.ensureVisible(find.text('Sign Up'));
    await tester.pump();
    await tester.tap(find.text('Sign Up'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('restores a remembered email address', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'agrovision.remember_me': true,
      'agrovision.remembered_email': 'remembered@example.com',
    });

    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.pump();
    await tester.pump();

    final field = tester.widget<TextFormField>(
      find.byType(TextFormField).first,
    );
    expect(field.controller?.text, 'remembered@example.com');
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
  });
}
