import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/widgets/form_field.dart';

class AddressField extends StatefulWidget {
  final Function onSaved;

  AddressField({
    this.onSaved,
  });

  @override
  _AddressFieldState createState() => _AddressFieldState();
}

class _AddressFieldState extends State<AddressField> {
  StreamController<String> _addressStreamController = StreamController();
  Map<String, dynamic> _address;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Field(
          readOnly: true,
          label: translate('field.address'),
          onSaved: (String value) {
            widget.onSaved(_address);
          },
          setStream: _addressStreamController.stream,
        ),
        ElevatedButton(
          child: Text('Choose Address'),
          onPressed: () {
            Navigator.pushNamed(context, '/address').then((value) {
              if (value != null) {
                _addressStreamController
                    .add((value as Map<String, dynamic>)['streetAddress']);

                setState(() {
                  _address = (value as Map<String, dynamic>)['address'];
                });
              }
            });
          },
        )
      ],
    );
  }
}
