import 'package:flutter/material.dart';

class FormSubmitButton extends StatelessWidget {
  final bool disabled;
  final Function onPressed;
  final String label;
  final Color color;

  FormSubmitButton({
    @required this.disabled,
    @required this.onPressed,
    @required this.label,
    this.color = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
      color: color,
      textColor: Colors.white,
      // disabledColor: Colors.blue[200],
      disabledTextColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: disabled ? null : onPressed,
      child: Text(label, style: TextStyle(fontSize: 16)),
    );
  }
}
