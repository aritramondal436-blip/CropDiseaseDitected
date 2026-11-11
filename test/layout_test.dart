import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:emergency_app/homescreen.dart';
import 'package:emergency_app/login_screen.dart';
import 'package:emergency_app/profile_screen.dart';
import 'package:emergency_app/signup_screen.dart';

/// Renders the sign-up page at [size] and scrolls through it,
/// failing if any widget overflows its bounds.
Future<void> expectSignupNoOverflowAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
  await tester.pump();

  for (var i = 0; i < 6; i++) {
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -400),
    );
    await tester.pump();
  }

  expect(tester.takeException(), isNull);
}

/// Renders the login page at [size] and scrolls through it,
/// failing if any widget overflows its bounds.
Future<void> expectLoginNoOverflowAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  final scrollables = find.byType(SingleChildScrollView);
  for (var i = 0; i < 4 && scrollables.evaluate().isNotEmpty; i++) {
    await tester.drag(scrollables.first, const Offset(0, -400));
    await tester.pump();
  }

  expect(tester.takeException(), isNull);
}

/// Renders the home page directly at [size] and scrolls through every
/// section, failing if any widget overflows its bounds.
Future<void> expectHomeNoOverflowAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  for (var i = 0; i < 6; i++) {
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -400),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  expect(tester.takeException(), isNull);
}

/// Renders the profile page at [size] and scrolls through it,
/// failing if any widget overflows its bounds.
Future<void> expectProfileNoOverflowAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    const MaterialApp(home: Scaffold(body: ProfileScreen())),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  final scrollables = find.byType(SingleChildScrollView);
  for (var i = 0; i < 6 && scrollables.evaluate().isNotEmpty; i++) {
    await tester.drag(scrollables.first, const Offset(0, -400));
    await tester.pump();
  }

  expect(tester.takeException(), isNull);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Profile layout', () {
    testWidgets(
      'small phone 320x568',
      (t) => expectProfileNoOverflowAt(t, const Size(320, 568)),
    );
    testWidgets(
      'phone 390x844',
      (t) => expectProfileNoOverflowAt(t, const Size(390, 844)),
    );
    testWidgets(
      'tablet 800x1000',
      (t) => expectProfileNoOverflowAt(t, const Size(800, 1000)),
    );
    testWidgets(
      'desktop 1280x800',
      (t) => expectProfileNoOverflowAt(t, const Size(1280, 800)),
    );
  });

  group('Login layout', () {
    testWidgets(
      'small phone 320x568',
      (t) => expectLoginNoOverflowAt(t, const Size(320, 568)),
    );
    testWidgets(
      'phone 360x800',
      (t) => expectLoginNoOverflowAt(t, const Size(360, 800)),
    );
    testWidgets(
      'phone 390x844',
      (t) => expectLoginNoOverflowAt(t, const Size(390, 844)),
    );
    testWidgets(
      'tall phone 412x915',
      (t) => expectLoginNoOverflowAt(t, const Size(412, 915)),
    );
    testWidgets(
      'tablet 800x1000',
      (t) => expectLoginNoOverflowAt(t, const Size(800, 1000)),
    );
    testWidgets(
      'desktop 1280x800',
      (t) => expectLoginNoOverflowAt(t, const Size(1280, 800)),
    );
  });

  group('Sign-up layout', () {
    testWidgets(
      'small phone 320x568',
      (t) => expectSignupNoOverflowAt(t, const Size(320, 568)),
    );
    testWidgets(
      'phone 360x800',
      (t) => expectSignupNoOverflowAt(t, const Size(360, 800)),
    );
    testWidgets(
      'phone 390x844',
      (t) => expectSignupNoOverflowAt(t, const Size(390, 844)),
    );
    testWidgets(
      'tall phone 412x915',
      (t) => expectSignupNoOverflowAt(t, const Size(412, 915)),
    );
    testWidgets(
      'tablet 800x1000',
      (t) => expectSignupNoOverflowAt(t, const Size(800, 1000)),
    );
  });

  group('Home layout', () {
    testWidgets(
      'small phone 320x568',
      (t) => expectHomeNoOverflowAt(t, const Size(320, 568)),
    );
    testWidgets(
      'phone 360x800',
      (t) => expectHomeNoOverflowAt(t, const Size(360, 800)),
    );
    testWidgets(
      'phone 390x844',
      (t) => expectHomeNoOverflowAt(t, const Size(390, 844)),
    );
    testWidgets(
      'tall phone 412x915',
      (t) => expectHomeNoOverflowAt(t, const Size(412, 915)),
    );
    testWidgets(
      'tablet 800x1000',
      (t) => expectHomeNoOverflowAt(t, const Size(800, 1000)),
    );
    testWidgets(
      'desktop 1280x800',
      (t) => expectHomeNoOverflowAt(t, const Size(1280, 800)),
    );
  });
}
