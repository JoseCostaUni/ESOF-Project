import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric enterName(String password) {
  return given<FlutterWorld>(
    'I enter the name "$password"',
    (context) async {
      // Find the name text field by its key
      final nameField = find.byValueKey('Password');

      // Enter the text "John" into the name field
      await FlutterDriverUtils.enterText(
          context.world.driver, nameField, password);
    },
  );
}
