import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:emergency_app/homescreen.dart';
import 'package:emergency_app/profile_screen.dart';
import 'package:emergency_app/top_header.dart';
import 'package:emergency_app/user_profile.dart';

Future<void> pumpProfile(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(home: Scaffold(body: ProfileScreen())),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('renders the demo profile and every section', (
    WidgetTester tester,
  ) async {
    await pumpProfile(tester);

    expect(find.text('User Name'), findsWidgets);
    expect(find.text('user@gmail.com'), findsWidgets);
    expect(find.text('Active User'), findsOneWidget);
    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Account Information'), findsOneWidget);
    expect(find.text('App Preferences'), findsOneWidget);
    expect(find.text('Other Options'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('Profile Picture'), findsOneWidget);
    expect(find.text('User ID'), findsOneWidget);
    expect(find.text('Account Type'), findsOneWidget);
    expect(find.text('Registration Date'), findsOneWidget);
    expect(find.text('Preferred Language'), findsOneWidget);
    expect(find.text('Notification Settings'), findsOneWidget);
    expect(find.text('Location Access'), findsOneWidget);
    expect(find.text('My Reports'), findsOneWidget);
    expect(find.text('Saved Plants'), findsOneWidget);
    expect(find.text('Help & Support'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('editing the profile updates and persists fields', (
    WidgetTester tester,
  ) async {
    await pumpProfile(tester);

    await tester.tap(find.text('Edit'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Edit Profile'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'New Farmer');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'new.farmer@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), '+91 90000 00000');
    await tester.enterText(find.byType(TextFormField).at(3), 'Pune');

    await tester.ensureVisible(find.text('Save Changes'));
    await tester.tap(find.text('Save Changes'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('New Farmer'), findsWidgets);
    expect(find.text('new.farmer@example.com'), findsWidgets);

    final saved = await const ProfileService().load();
    expect(saved.fullName, 'New Farmer');
    expect(saved.email, 'new.farmer@example.com');
    expect(saved.phone, '+91 90000 00000');
    expect(saved.location, 'Pune');
  });

  testWidgets('preference toggles persist', (WidgetTester tester) async {
    await pumpProfile(tester);

    final notifications = find.byType(Switch).first;
    await tester.ensureVisible(notifications);
    expect(tester.widget<Switch>(notifications).value, isTrue);

    await tester.tap(notifications);
    await tester.pump();
    await tester.pump();

    expect(tester.widget<Switch>(notifications).value, isFalse);
    final saved = await const ProfileService().load();
    expect(saved.notificationsEnabled, isFalse);
  });

  testWidgets('placeholder option opens its info page', (
    WidgetTester tester,
  ) async {
    await pumpProfile(tester);

    await tester.ensureVisible(find.text('Saved Plants'));
    await tester.tap(find.text('Saved Plants'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Plants you save will be listed here.'), findsOneWidget);
  });

  testWidgets('logout returns to the login screen', (
    WidgetTester tester,
  ) async {
    await pumpProfile(tester);

    await tester.ensureVisible(find.text('Logout'));
    await tester.tap(find.text('Logout'));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Logout'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Welcome Back!'), findsOneWidget);
  });

  testWidgets('bottom nav Profile tab opens the profile', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pump();

    await tester.tap(find.text('Profile'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Personal Information'), findsOneWidget);
  });

  testWidgets('header avatar opens the profile', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pump();

    final avatar = find.descendant(
      of: find.byType(TopHeader),
      matching: find.byIcon(Icons.person_rounded),
    );
    await tester.tap(avatar);
    await tester.pump();
    await tester.pump();

    expect(find.text('Personal Information'), findsOneWidget);
  });
}
