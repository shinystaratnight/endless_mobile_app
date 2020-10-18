import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  final String label;
  final Function onFocus;
  final Function validator;
  final Function onSaved;
  final TextInputType type;
  final bool obscureText;
  final initialValue;

  Field({
    this.label,
    this.initialValue,
    this.validator,
    this.onSaved,
    this.onFocus,
    this.obscureText = false,
    this.type = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        onTap: onFocus,
        validator: validator,
        initialValue: initialValue,
        obscureText: obscureText,
        keyboardType: type,
        onSaved: onSaved,
      ),
    );
  }
}
