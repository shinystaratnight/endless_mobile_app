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
