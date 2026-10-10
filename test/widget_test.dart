import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:emergency_app/app.dart';
import 'package:emergency_app/weather_service.dart';

void main() {
  testWidgets('Sign-up screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AgroVisionApp());
    await tester.pump();

    expect(find.text('AgroVision'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Or sign up with'), findsOneWidget);
    expect(find.textContaining('Already have an account?'), findsOneWidget);
  });

  testWidgets('Register with valid details opens the home page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AgroVisionApp());
    await tester.pump();

    await tester.enterText(find.byType(TextFormField).at(0), 'Test Farmer');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'farmer@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'secret123');
    await tester.enterText(find.byType(TextFormField).at(3), 'secret123');
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    await tester.ensureVisible(find.text('Register'));
    await tester.tap(find.text('Register'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Healthy Crops, Brighter Tomorrow'), findsOneWidget);
  });

  group('WeatherData.fromJson', () {
    test('parses current weather payload', () {
      final data = WeatherData.fromJson(
        const {
          'current': {
            'temperature_2m': 32.0,
            'relative_humidity_2m': 68,
            'wind_speed_10m': 12.0,
            'weather_code': 2,
          },
        },
        city: 'Khastika',
      );

      expect(data.city, 'Khastika');
      expect(data.tempC, 32);
      expect(data.conditionText, 'Partly cloudy');
      expect(data.conditionCode, 2);
      expect(data.humidity, 68);
      expect(data.windKph, 12);
    });

    test('rounds decimals and handles missing fields', () {
      final data = WeatherData.fromJson(const {});
      expect(data.tempC, 0);
      expect(data.city, 'Unknown');
    });
  });

  group('WeatherService.weatherIcon', () {
    test('maps WMO condition codes to icons', () {
      expect(WeatherService.weatherIcon(0), Icons.wb_sunny_rounded);
      expect(WeatherService.weatherIcon(2), Icons.wb_cloudy_rounded);
      expect(WeatherService.weatherIcon(61), Icons.water_drop_rounded);
      expect(WeatherService.weatherIcon(73), Icons.ac_unit_rounded);
      expect(WeatherService.weatherIcon(95), Icons.flash_on_rounded);
    });
  });
}
