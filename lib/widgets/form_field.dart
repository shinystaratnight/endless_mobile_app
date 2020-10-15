import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  final String label;
  final Function onFocus;
  final initialValue;

  Field({this.label, this.onFocus, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
          decoration: InputDecoration(labelText: label),
          validator: (String value) {
            return null;
          },
          initialValue: initialValue,
          onTap: onFocus,
          onSaved: (String value) {}),
    );
  }
}
