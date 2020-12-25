import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:piiprent/widgets/group_title.dart';
import 'package:provider/provider.dart';

class CandidateTimesheetDetailsScreen extends StatefulWidget {
  final String position;
  final String jobsite;
  final String clientContact;
  final String address;
  final DateTime shiftDate;
  final DateTime shiftStart;
  final DateTime shiftEnd;
  final DateTime breakStart;
  final DateTime breakEnd;
  final int status;
  final String id;

  CandidateTimesheetDetailsScreen({
    this.position = '',
    this.jobsite,
    this.clientContact,
    this.address,
    this.shiftDate,
    this.shiftStart,
    this.shiftEnd,
    this.breakStart,
    this.breakEnd,
    this.status,
    this.id,
  });

  @override
  _CandidateTimesheetDetailsScreenState createState() =>
      _CandidateTimesheetDetailsScreenState();
}

class _CandidateTimesheetDetailsScreenState
    extends State<CandidateTimesheetDetailsScreen> {
  bool _updated = false;
  bool _fetching = false;

  String _shiftStart = TimesheetTimeKey[TimesheetTime.Start];
  String _breakStart = TimesheetTimeKey[TimesheetTime.BreakStart];
  String _breakEnd = TimesheetTimeKey[TimesheetTime.BreakEnd];
  String _shiftEnd = TimesheetTimeKey[TimesheetTime.End];

  Map<String, DateTime> _times = Map();

  @override
  void initState() {
    _times = {
      _shiftStart: widget.shiftStart,
      _breakStart: widget.breakStart,
      _breakEnd: widget.breakEnd,
      _shiftEnd: widget.shiftEnd
    };
    super.initState();
  }

  _acceptPreShiftCheck(TimesheetService timesheetService) async {
    try {
      setState(() => _fetching = true);
      bool result = await timesheetService.acceptPreShiftCheck(widget.id);

      setState(() => _updated = result);
    } catch (e) {
      print(e);
    } finally {
      setState(() => _fetching = false);
    }
  }

  _declinePreShiftCheck(TimesheetService timesheetService) async {
    try {
      setState(() => _fetching = true);
      bool result = await timesheetService.declinePreShiftCheck(widget.id);

      setState(() => _updated = result);
    } catch (e) {
      print(e);
    } finally {
      setState(() => _fetching = false);
    }
  }

  _changeTime(DateTime time, String key) {
    setState(() {
      _times[key] = time;
    });
  }

  _submitForm(TimesheetService timesheetService) async {
    try {
      setState(() => _fetching = true);
      Map<String, String> body =
          _times.map((key, value) => MapEntry(key, value.toUtc().toString()));
      bool result = await timesheetService.submitTimesheet(widget.id, body);

      setState(() => _updated = result);
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
      appBar: getCandidateAppBar(
        'Timesheet',
        context,
        showNotification: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_left,
                size: 36.0,
              ),
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
              Text(
                widget.position,
                style: TextStyle(fontSize: 22.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15.0,
              ),
              GroupTitle(title: 'Times'),
              DetailsRecord(
                label: 'Shift Date',
                value: DateFormat('dd/MM/yyyy').format(widget.shiftDate),
              ),
              DetailsRecord(
                label: 'Shift Start Time',
                value: DateFormat.jm().format(_times[_shiftStart]),
                button: widget.status == 4 && !_updated
                    ? _buildChangeButton(
                        _times[_shiftStart],
                        _shiftStart,
                      )
                    : null,
              ),
              DetailsRecord(
                label: 'Break Start Time',
                value: DateFormat.jm().format(_times[_breakStart]),
                button: widget.status == 4 && !_updated
                    ? _buildChangeButton(
                        _times[_breakStart],
                        _breakStart,
                      )
                    : null,
              ),
              DetailsRecord(
                label: 'Break End Time',
                value: DateFormat.jm().format(_times[_breakEnd]),
                button: widget.status == 4 && !_updated
                    ? _buildChangeButton(
                        _times[_breakEnd],
                        _breakEnd,
                      )
                    : null,
              ),
              DetailsRecord(
                label: 'Shift End Time',
                value: DateFormat.jm().format(_times[_shiftEnd]),
                button: widget.status == 4 && !_updated
                    ? _buildChangeButton(
                        _times[_shiftEnd],
                        _shiftEnd,
                      )
                    : null,
              ),
              GroupTitle(title: 'Job Information'),
              DetailsRecord(
                label: 'Jobsite',
                value: widget.jobsite,
              ),
              DetailsRecord(
                label: 'Site Manager',
                value: widget.clientContact,
              ),
              DetailsRecord(
                label: 'Address',
                value: widget.address,
              ),
              widget.status == 1 && !_updated
                  ? Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Center(
                            child: Text(
                              'Confirm if you are going to work',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FormSubmitButton(
                              label: 'Decline',
                              onPressed: () =>
                                  _declinePreShiftCheck(timesheetService),
                              disabled: _fetching,
                              color: Colors.red[400],
                            ),
                            FormSubmitButton(
                              label: 'Accept',
                              onPressed: () =>
                                  _acceptPreShiftCheck(timesheetService),
                              disabled: _fetching,
                              color: Colors.green[400],
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),
              widget.status == 4 && !_updated
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
