import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric TapNextButton() {
  return when<FlutterWorld>(
    'I tap the Next button',
    (context) async {
      // Find the Next button by its key
      final nextButton = find.byValueKey('Next');

      // Tap the Next button
      await FlutterDriverUtils.tap(context.world.driver, nextButton);
    },
  );
}
