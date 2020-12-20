import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/evaluate.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:piiprent/widgets/group_title.dart';
import 'package:provider/provider.dart';

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
  bool _updated = false;
  bool _fetching = false;

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

  _changeTime(DateTime time, String key) {
    setState(() {
      _times[key] = time;
    });
  }

  _submitForm(TimesheetService timesheetService) async {
    try {
      setState(() => _fetching = true);
      // bool result = await timesheetService.approveTimesheet(
      //     widget.timesheet.id, _times, _updated);

      // setState(() => _updated = result);
    } catch (e) {
      print(e);
    } finally {
      setState(() => _fetching = false);
    }
  }

  Widget _buildChangeButton(DateTime date, String key) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.edit,
            size: 18.0,
            color: Colors.blue,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              'Change',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(date),
        ).then((time) {
          int hours = time.hour - date.hour;
          int minutes = time.minute - date.minute;

          if (hours > 0) {
            date = date.add(Duration(hours: hours.abs()));
          }

          if (hours < 0) {
            date = date.subtract(Duration(hours: hours.abs()));
          }

          if (minutes > 0) {
            date = date.add(Duration(minutes: minutes.abs()));
          }

          if (minutes < 0) {
            date = date.subtract(Duration(minutes: minutes.abs()));
          }

          _changeTime(
            date,
            key,
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TimesheetService timesheetService = Provider.of<TimesheetService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Timesheet'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Navigator.pop(context, _updated);
              },
            );
          },
        ),
      ),
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
                                widget.timesheet.candidateAvatarUrl,
                              ),
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
                button: widget.timesheet.status == 5 && !_updated
                    ? _buildChangeButton(
                        _times[_shiftStart],
                        _shiftStart,
                      )
                    : null,
              ),
              DetailsRecord(
                label: 'Break Start Time',
                value: DateFormat.jm().format(_times[_breakStart]),
                button: widget.timesheet.status == 5 && !_updated
                    ? _buildChangeButton(
                        _times[_breakStart],
                        _breakStart,
                      )
                    : null,
              ),
              DetailsRecord(
                label: 'Break End Time',
                value: DateFormat.jm().format(_times[_breakEnd]),
                button: widget.timesheet.status == 5 && !_updated
                    ? _buildChangeButton(
                        _times[_breakEnd],
                        _breakEnd,
                      )
                    : null,
              ),
              DetailsRecord(
                label: 'Shift End Time',
                value: DateFormat.jm().format(_times[_shiftEnd]),
                button: widget.timesheet.status == 5 && !_updated
                    ? _buildChangeButton(
                        _times[_shiftEnd],
                        _shiftEnd,
                      )
                    : null,
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
              widget.timesheet.status == 5 && !_updated
                  ? FormSubmitButton(
                      label: 'Submit',
                      onPressed: () => _submitForm(timesheetService),
                      disabled: _fetching,
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
