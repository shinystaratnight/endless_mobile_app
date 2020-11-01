import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/widgets/form_field.dart';

class FilterDialog extends StatefulWidget {
  final from;
  final to;

  FilterDialog({this.from, this.to});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  DateTime _from;
  DateTime _to;

  _setToday() {
    setState(() {
      _from = DateTime.now();
      _to = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: _setToday,
                child: Text('Today', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(
                width: 8.0,
              ),
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: () {},
                child: Text('Yesterday', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(
                width: 8.0,
              ),
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: () {},
                child: Text('This week', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: () {},
                child: Text('Last week', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(
                width: 8.0,
              ),
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: () {},
                child:
                    Text('This month', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(
                width: 8.0,
              ),
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: () {},
                child:
                    Text('Last month', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Field(
                initialValue:
                    _from != null ? DateFormat('dd/MM/yyyy').format(_from) : '',
                label: 'From',
              ),
            ),
            Expanded(
              child: Field(
                initialValue:
                    _to != null ? DateFormat('dd/MM/yyyy').format(_to) : '',
                label: 'To',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
