import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric BeingOntheSignUpPage() {
  return given<FlutterWorld>(
    'I am on the sign-up page',
    (context) async {
      // Assuming there's a button to navigate to the sign-up page with key 'signupButton'
      final signUpButton = find.byValueKey('Next');
      final insertEmailLabel = find.byValueKey('Email');
      final insertNameLabel = find.byValueKey('Name');
      final insertPassWordLabel = find.byValueKey('Password');

      final signUpButtonPresent = await FlutterDriverUtils.isPresent(
          context.world.driver, signUpButton);
      final insertEmailLabelPresent = await FlutterDriverUtils.isPresent(
          context.world.driver, insertEmailLabel);
      final insertNameLabelPresent = await FlutterDriverUtils.isPresent(
          context.world.driver, insertNameLabel);
      final insertPassWordLabelPresent = await FlutterDriverUtils.isPresent(
          context.world.driver, insertPassWordLabel);

      bool areAllPresent = false;

      if (signUpButtonPresent &&
          insertEmailLabelPresent &&
          insertNameLabelPresent &&
          insertPassWordLabelPresent) {
        areAllPresent = true;
      } else {
        areAllPresent = false;
      }
    },
  );
}
