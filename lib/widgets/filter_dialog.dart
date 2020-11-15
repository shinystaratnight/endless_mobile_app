import 'package:flutter/material.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'dart:async';
import 'package:jiffy/jiffy.dart';

class FilterDialog extends StatefulWidget {
  final DateTime from;
  final DateTime to;
  final Function onChange;

  FilterDialog({this.from, this.to, this.onChange});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  StreamController _dataStreamController = StreamController.broadcast();
  StreamController _fromStreamController = StreamController();
  StreamController _toStreamController = StreamController();

  get stream {
    return _dataStreamController.stream;
  }

  _emit(DateTime from, DateTime to) {
    Map<String, DateTime> data = {"from": from, "to": to};

    _dataStreamController.add(data);
  }

  @override
  initState() {
    super.initState();
    _dataStreamController.stream.listen((event) {
      if (widget.onChange != null) {
        widget.onChange(event);
      }
    });

    if (widget.from != null || widget.to != null) {
      _emit(widget.from, widget.to);
    }
  }

  _setToday() {
    DateTime now = DateTime.now();
    _emit(now, now);
  }

  _setYesterday() {
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    _emit(yesterday, yesterday);
  }

  _setThisWeek() {
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));
    DateTime sunday = now.add(Duration(days: 7 - now.weekday));
    _emit(monday, sunday);
  }

  _setLastWeek() {
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));
    DateTime sunday = now.add(Duration(days: 7 - now.weekday));
    _emit(
      monday.subtract(Duration(days: 7)),
      sunday.subtract(Duration(days: 7)),
    );
  }

  _setThisMonth() {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime.utc(now.year, now.month, 1);
    DateTime lastDayofMonth = Jiffy().endOf(Units.MONTH);
    _emit(firstDayOfMonth, lastDayofMonth);
  }

  _setLastMonth() {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime.utc(now.year, now.month, 1);
    DateTime firstDayOfLastMonth =
        Jiffy(firstDayOfMonth.subtract(Duration(days: 1))).startOf(Units.MONTH);
    DateTime lastDayOfLastMonth =
        Jiffy(firstDayOfMonth.subtract(Duration(days: 1))).endOf(Units.MONTH);
    _emit(firstDayOfLastMonth, lastDayOfLastMonth);
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
                onPressed: _setYesterday,
                child: Text('Yesterday', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(
                width: 8.0,
              ),
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: _setThisWeek,
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
                onPressed: _setLastWeek,
                child: Text('Last week', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(
                width: 8.0,
              ),
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: _setThisMonth,
                child:
                    Text('This month', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(
                width: 8.0,
              ),
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: _setLastMonth,
                child:
                    Text('Last month', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
        StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            DateTime from;
            DateTime to;

            if (snapshot.hasData) {
              from = snapshot.data["from"];
              to = snapshot.data["to"];

              if (from != null) {
                _fromStreamController.add(from);
              }

              if (to != null) {
                _toStreamController.add(to);
              }
            }

            return Row(
              children: [
                Expanded(
                  child: Field(
                    label: 'From',
                    datepicker: true,
                    setStream: _fromStreamController.stream,
                    onChanged: (data) {
                      print(data);
                      _emit(data, to);
                    },
                  ),
                ),
                Expanded(
                  child: Field(
                    label: 'To',
                    datepicker: true,
                    setStream: _toStreamController.stream,
                    onChanged: (data) {
                      _emit(from, data);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
