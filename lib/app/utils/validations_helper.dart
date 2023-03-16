import 'package:form_field_validator/form_field_validator.dart';

const requiredErrorText = 'This field is required';
const validEmailErrorText = 'Email must be valid';

final strongPasswordValidator = MultiValidator([
  RequiredValidator(errorText: requiredErrorText),
  MinLengthValidator(8,
      errorText: 'Password length must be at least 8 characters long.'),
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: requiredErrorText),
  EmailValidator(errorText: validEmailErrorText),
]);
