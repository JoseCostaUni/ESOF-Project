import 'package:app/screens/editprofile.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';
import 'dart:async';

StepDefinitionGeneric BeingOntheSignUpPage() {
  return given<FlutterWorld>(
    'I am on the sign-up page',
    (context) async {
      // Assuming there's a button to navigate to the sign-up page with key 'signupButton'
      final editProfile = find.byValueKey('edit_profile');

      final editProfilebutton =
          await FlutterDriverUtils.isPresent(context.world.driver, editProfile);

      final completer = Completer<void>();

      if (editProfilebutton) {
        completer.complete();
      } else {
        completer.completeError('Not all elements are present');
      }

      return completer.future;
    },
  );
}
