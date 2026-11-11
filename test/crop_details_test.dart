import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:emergency_app/crop_data.dart';
import 'package:emergency_app/crop_details_page.dart';
import 'package:emergency_app/popular_cart.dart';

void main() {
  testWidgets('tapping a crop opens its details page', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: PopularCrops()),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Tomato'));
    await tester.pumpAndSettle();

    expect(find.text('Crop Details'), findsOneWidget);
    expect(find.text('Solanum lycopersicum'), findsOneWidget);
    expect(find.text('Common Diseases'), findsOneWidget);
    expect(find.text('Early Blight'), findsOneWidget);
    expect(find.text('Late Blight'), findsOneWidget);
    expect(find.text('Leaf Mold'), findsOneWidget);
    expect(find.text('Scan Tomato Leaf'), findsOneWidget);
  });

  testWidgets('expanding a disease shows symptoms and guidance', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: CropDetailsPage(crop: cropByName('Tomato')!)),
    );
    await tester.pump();

    await tester.ensureVisible(find.text('Early Blight'));
    await tester.tap(find.text('Early Blight'));
    await tester.pumpAndSettle();

    expect(find.text('Symptoms'), findsOneWidget);
    expect(find.text('Identification'), findsOneWidget);
    expect(find.text('Prevention'), findsOneWidget);
    expect(find.text('Treatment'), findsOneWidget);
    expect(find.textContaining('concentric rings'), findsOneWidget);
  });
}
