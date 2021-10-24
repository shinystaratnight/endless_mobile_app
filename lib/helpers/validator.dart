bool isEmail(String value) {
  if (value.contains('@')) {
    return true;
  }

  return false;
}

String emailValidator(String value) {
  if (isEmail(value)) {
    return null;
  }
  return 'Please enter a valid email!';
}

String numberValidator(String value) {
  try {
    double.parse(value);

    return null;
  } catch (e) {
    return 'Please enter a valid number!';
  }
}

String requiredValidator(dynamic value) {
  if (value != null) {
    return null;
  }

  return 'This field is required';
}
