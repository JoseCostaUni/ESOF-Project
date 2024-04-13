import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric ExpectProfilePage() {
  return then('I expect to be on the profile page', (context) async {
    //get widget
    //get title
    //store title on actual
    String actual = 'profile';
    context.expectMatch(actual, 'profile');
  });
}
