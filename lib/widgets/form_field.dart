import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Field extends StatefulWidget {
  final String label;
  final Function onFocus;
  final Function validator;
  final Function onSaved;
  final TextInputType type;
  final bool obscureText;
  final initialValue;
  final bool datepicker;
  final bool readOnly;

  Field({
    this.label,
    this.initialValue,
    this.validator,
    this.onSaved,
    this.onFocus,
    this.obscureText = false,
    this.type = TextInputType.text,
    this.datepicker = false,
    this.readOnly = false,
  });

  @override
  _FieldState createState() => _FieldState();
}

class _FieldState extends State<Field> {
  final myController = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    myController.text = widget.initialValue;
    if (widget.datepicker && widget.initialValue != null) {
      _date = DateTime.parse(widget.initialValue);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: myController,
        decoration: InputDecoration(labelText: widget.label),
        onTap: widget.datepicker
            ? () {
                showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                ).then((date) {
                  setState(() {
                    myController.text = DateFormat('dd/MM/yyyy').format(date);
                    setState(() {
                      _date = date;
                    });
                  });
                });
              }
            : widget.onFocus,
        validator: widget.validator,
        // initialValue: widget.initialValue,
        obscureText: widget.obscureText,
        keyboardType: widget.type,
        onSaved: widget.onSaved,
        readOnly: widget.datepicker || widget.readOnly,
      ),
    );
  }

  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    myController.dispose();
    super.dispose();
  }
}
