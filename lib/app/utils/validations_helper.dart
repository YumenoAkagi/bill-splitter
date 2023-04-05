import 'package:form_field_validator/form_field_validator.dart';

const requiredErrorText = 'This field is required';
const validEmailErrorText = 'Email must be valid';
const unexpectedErrorText = 'Unexpected error occurred';

final strongPasswordValidator = MultiValidator([
  RequiredValidator(errorText: requiredErrorText),
  MinLengthValidator(8,
      errorText: 'Password length must be at least 8 characters long.'),
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: requiredErrorText),
  EmailValidator(errorText: validEmailErrorText),
]);

final qtyAndPriceValidator = MultiValidator([
  RequiredValidator(errorText: requiredErrorText),
  GreaterThanZeroValidator('Value must be greater than 0'),
]);

class GreaterThanZeroValidator extends FieldValidator<num> {
  GreaterThanZeroValidator(String errorText) : super(errorText);

  @override
  bool isValid(num value) {
    if (value < 0) return false;
    return true;
  }
}
