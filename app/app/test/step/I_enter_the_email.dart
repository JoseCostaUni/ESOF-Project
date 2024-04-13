import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric EnterEmail(String email) {
  return given<FlutterWorld>(
    'I enter the name "$email"',
    (context) async {
      // Find the name text field by its key
      final nameField = find.byValueKey('Email');

      // Enter the text "John" into the name field
      await FlutterDriverUtils.enterText(
          context.world.driver, nameField, email);
    },
  );
}
