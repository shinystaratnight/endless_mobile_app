import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/widgets/filter_dialog.dart';

class FilterDialogButton extends StatefulWidget {
  final DateTime from;
  final DateTime to;
  final Function onClose;

  FilterDialogButton({
    this.from,
    this.to,
    @required this.onClose,
  });

  @override
  _FilterDialogButtonState createState() => _FilterDialogButtonState();
}

class _FilterDialogButtonState extends State<FilterDialogButton> {
  DateTime _from;
  DateTime _to;

  @override
  void initState() {
    _from = widget.from;
    _to = widget.to;
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

  _onClose(dynamic event) {
    if (event == FilterDialogResult.Submit) {
      widget.onClose({"from": _from, "to": _to});
    } else if (event == FilterDialogResult.Clear) {
      widget.onClose({"from": null, "to": null});
    } else {
      widget.onClose({"from": widget.from, "to": widget.to});
    }
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actions: [
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pop(FilterDialogResult.Clear);
            },
            child: Text('Clear'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pop(FilterDialogResult.Submit);
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
        content: FilterDialog(
          from: _from,
          to: _to,
          onChange: (Map<String, DateTime> data) {
            setState(() {
              _from = data["from"];
              _to = data["to"];
            });
          },
        ),
      ),
    ).then(_onClose);
  }
}
