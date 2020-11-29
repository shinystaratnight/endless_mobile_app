import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/evaluate.dart';
import 'package:piiprent/widgets/group_title.dart';

class ClientTimesheetDetailsScreen extends StatefulWidget {
  final Timesheet timesheet;

  ClientTimesheetDetailsScreen({
    this.timesheet,
  });

  @override
  _ClientTimesheetDetailsScreenState createState() =>
      _ClientTimesheetDetailsScreenState();
}

class _ClientTimesheetDetailsScreenState
    extends State<ClientTimesheetDetailsScreen> {
  String _shiftStart = TimesheetTimeKey[TimesheetTime.Start];
  String _breakStart = TimesheetTimeKey[TimesheetTime.BreakStart];
  String _breakEnd = TimesheetTimeKey[TimesheetTime.BreakEnd];
  String _shiftEnd = TimesheetTimeKey[TimesheetTime.End];

  Map<String, DateTime> _times = Map();

  @override
  void initState() {
    _times = {
      _shiftStart: widget.timesheet.shiftStart,
      _breakStart: widget.timesheet.breakStart,
      _breakEnd: widget.timesheet.breakEnd,
      _shiftEnd: widget.timesheet.shiftEnd
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timesheet')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                      image: widget.timesheet.candidateAvatarUrl != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  widget.timesheet.candidateAvatarUrl),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                widget.timesheet.candidateName,
                style: TextStyle(fontSize: 26.0, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.timesheet.position,
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15.0,
              ),
              GroupTitle(title: 'Times'),
              DetailsRecord(
                label: 'Shift Date',
                value: DateFormat('dd/MM/yyyy').format(_times[_shiftStart]),
              ),
              DetailsRecord(
                label: 'Shift Start Time',
                value: DateFormat.jm().format(_times[_shiftStart]),
              ),
              DetailsRecord(
                label: 'Break Start Time',
                value: DateFormat.jm().format(_times[_breakStart]),
              ),
              DetailsRecord(
                label: 'Break End Time',
                value: DateFormat.jm().format(_times[_breakEnd]),
              ),
              DetailsRecord(
                label: 'Shift End Time',
                value: DateFormat.jm().format(_times[_shiftEnd]),
              ),
              DetailsRecord(
                label: 'Jobsite',
                value: widget.timesheet.jobsite,
              ),
              !widget.timesheet.evaluated
                  ? Evaluate(
                      active: true,
                      score: 1,
                      onChange: (score) {
                        print(score);
                      },
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
