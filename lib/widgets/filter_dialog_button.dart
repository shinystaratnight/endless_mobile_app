import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:piiprent/widgets/filter_dialog.dart';

class FilterDialogButton extends StatefulWidget {
  final DateTime from;
  final DateTime to;

  FilterDialogButton({
    this.from,
    this.to,
  });

  @override
  _FilterDialogButtonState createState() => _FilterDialogButtonState();
}

class _FilterDialogButtonState extends State<FilterDialogButton> {
  DateTime _from;
  DateTime _to;

  @override
  void initState() {
    _from = widget.from != null ? widget.from : null;
    _to = widget.to != null ? widget.to : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _showDialog,
      child: Icon(
        Icons.filter_list,
        color: Colors.blue,
      ),
      backgroundColor: Colors.white,
    );
  }

  // _setToday() {
  //   setState(() {
  //     _from = DateTime.now();
  //     _to = DateTime.now();
  //   });
  // }

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
        contentPadding: const EdgeInsets.all(8.0),
        titlePadding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
        content: FilterDialog(),
      ),
    );
  }
}
