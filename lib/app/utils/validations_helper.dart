String? isNotEmptyString(String? value) {
  if (value == null || value.isEmpty) return 'This field is required.';
  return null;
}

String? isEmailValid(String? email) {
  String? error = isNotEmptyString(email);
  if (error != null) return error;

  final bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email!);

  if (!emailValid) return 'Please enter valid email';
  return null;
}

String? isStrongPassword(String? value) {
  String? error = isNotEmptyString(value);
  if (error != null) return error;

  if (value!.length < 8) {
    return 'Password length must be minimal 8 character(s)';
  }

  return null;
}
