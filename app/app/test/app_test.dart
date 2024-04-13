import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'step/I_enter_the_email.dart';
import 'step/I_enter_the_name.dart';
import 'step/I_enter_the_password.dart';
import 'step/I_enter_the_surname.dart';
import 'step/I_submit_the_signup_form.dart';
import 'step/the_user_is_on_the_sign-up_page.dart';

Future<void> main() async {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/search_people.feature")]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './test_report.json')
    ]
    ..stepDefinitions = [
      BeingOntheSignUpPage(),
      EnterName("John"),
      EnterSurname("Doe"),
      EnterEmail("john.doe@example.com"),
      EnterPassword("password123"),
      TapNextButton(),
    ]
    ..customStepParameterDefinitions = []
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";
  return GherkinRunner().execute(config);
}
