import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:emergency_app/all_crops_page.dart';
import 'package:emergency_app/popular_cart.dart';

void main() {
  testWidgets('View All opens the crop library', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: PopularCrops()),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('View All'));
    await tester.pumpAndSettle();

    expect(find.text('All Crops'), findsOneWidget);
    expect(find.text('Tomato'), findsOneWidget);
    expect(find.text('Potato'), findsOneWidget);
  });

  testWidgets('search filters the crop library', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AllCropsPage()));
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('crop-search-field')),
      'soy',
    );
    await tester.pumpAndSettle();

    expect(find.text('Soybean'), findsOneWidget);
    expect(find.text('Tomato'), findsNothing);
  });

  testWidgets('season filter narrows the crop library', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AllCropsPage()));
    await tester.pump();

    await tester.tap(find.byKey(const Key('season-chip-Spring')));
    await tester.pumpAndSettle();

    expect(find.text('Corn'), findsOneWidget);
    expect(find.text('Tomato'), findsNothing);
  });

  testWidgets('empty search shows the empty state', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AllCropsPage()));
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('crop-search-field')),
      'zzzz',
    );
    await tester.pumpAndSettle();

    expect(find.text('No crops found'), findsOneWidget);
  });

  testWidgets('tapping a crop opens its details page', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AllCropsPage()));
    await tester.pump();

    await tester.tap(find.byKey(const Key('crop-card-Tomato')));
    await tester.pumpAndSettle();

    expect(find.text('Crop Details'), findsOneWidget);
    expect(find.text('Common Diseases'), findsOneWidget);
    expect(find.text('Scan Tomato Leaf'), findsOneWidget);
  });
}
