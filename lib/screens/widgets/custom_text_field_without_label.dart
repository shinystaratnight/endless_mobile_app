import 'package:flutter/material.dart';
import 'package:piiprent/constants.dart';

class CustomTextFieldWIthoutLabel extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final Function validator;
  final bool passowrd;
  final TextInputType type;
  const CustomTextFieldWIthoutLabel({
    Key key,
    this.hint,
    this.onChanged,
    this.controller,
    this.validator,
    this.passowrd,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: type,
      obscureText: passowrd ?? false,
      validator: validator,
      onChanged: onChanged,
      style: TextStyle(color: activeTextColor, fontSize: 16),
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: hintColor, width: 1.0),
            borderRadius: BorderRadius.circular(8),
          ),
          focusColor: primaryColor,
          fillColor: whiteColor,
          filled: true,
          isDense: true,
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          hintStyle: TextStyle(color: hintColor, fontSize: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
    );
  }
}
