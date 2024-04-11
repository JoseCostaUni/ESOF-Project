import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/screens/homepage.dart';
import 'package:app/screens/eventsearch.dart';

void main() {
  testWidgets('Navigate to Event Search Page', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage(title: 'Test')));

    expect(find.byIcon(Icons.search), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.byType(EventSearch), findsOneWidget);
  });
}
