import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:piiprent/widgets/form_field.dart';

class FilterDialogButton extends StatefulWidget {
  @override
  _FilterDialogButtonState createState() => _FilterDialogButtonState();
}

class _FilterDialogButtonState extends State<FilterDialogButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _showDialog,
      child: Icon(Icons.filter_list),
    );
  }

  _buildButton() {}

  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actions: [
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Clear'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.blueAccent,
            child: Text('Submit'),
          ),
        ],
        title: Text('Choose Dates'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  RaisedButton(
                    color: Colors.blueAccent,
                    onPressed: () {},
                    child: Text('Today', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  RaisedButton(
                    color: Colors.blueAccent,
                    onPressed: () {},
                    child: Text('Yesterday',
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  RaisedButton(
                    color: Colors.blueAccent,
                    onPressed: () {},
                    child: Text('This week',
                        style: TextStyle(color: Colors.white)),
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
                    child: Text('Last week',
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  RaisedButton(
                    color: Colors.blueAccent,
                    onPressed: () {},
                    child: Text('This month',
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  RaisedButton(
                    color: Colors.blueAccent,
                    onPressed: () {},
                    child: Text('Last month',
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Field(
                    label: 'From',
                  ),
                ),
                Expanded(
                  child: Field(
                    label: 'To',
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
