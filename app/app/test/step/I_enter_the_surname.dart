import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric EnterSurname(String surname) {
  return given<FlutterWorld>(
    'I enter the name "$surname"',
    (context) async {
      // Find the name text field by its key
      final nameField = find.byValueKey('Surname');

      // Enter the text "John" into the name field
      await FlutterDriverUtils.enterText(
          context.world.driver, nameField, surname);
    },
  );
}
