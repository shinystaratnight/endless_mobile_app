import 'package:flutter/material.dart';

class DetailsRecord extends StatelessWidget {
  final String label;
  final String value;

  DetailsRecord({this.label, this.value = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label),
          ),
          Text(':'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(value),
            ),
          ),
        ],
      ),
    );
  }
}
