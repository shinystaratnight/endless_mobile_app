import 'package:flutter/material.dart';

class FormSubmitButton extends StatelessWidget {
  final bool disabled;
  final Function onPressed;
  final String label;
  final Color color;
  final double horizontalPadding;

  FormSubmitButton({
    @required this.disabled,
    @required this.onPressed,
    @required this.label,
    this.color = Colors.blueAccent,
    this.horizontalPadding = 60,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      disabledColor: color,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 10,
      ),
      color: color,
      textColor: Colors.white,
      // disabledColor: Colors.blue[200],
      disabledTextColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: disabled ? null : onPressed,
      child: disabled ?? false
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Text(label, style: TextStyle(fontSize: 16)),
    );
  }
}
