import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';
import 'dart:async';

StepDefinitionGeneric BeingOntheProfilePage() {
  return then<FlutterWorld>(
    'I am on the profile page',
    (context) async {
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

      final completer = Completer<void>();

      if (signUpButtonPresent &&
          insertEmailLabelPresent &&
          insertNameLabelPresent &&
          insertPassWordLabelPresent) {
        completer.complete();
      } else {
        completer.completeError('Not all elements are present');
      }

      return completer.future;
    },
  );
}
