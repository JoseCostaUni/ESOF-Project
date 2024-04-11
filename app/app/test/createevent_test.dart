import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/screens/createevent.dart';

void main() {
  testWidgets('Create Event Page UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CreateEvent()));
    expect(find.text('Create Event').first, findsOneWidget); 
    expect(find.byType(TextField), findsNWidgets(6));
  });
}
