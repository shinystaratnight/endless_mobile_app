import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/services/skill_activity_service.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:piiprent/widgets/group_title.dart';
import 'package:piiprent/widgets/skill_activity_table.dart';
import 'package:provider/provider.dart';

import 'activitywidget_page.dart';
import 'timewidget_page.dart';
import 'widgets/timesheet_general_info_widget.dart';

class CandidateTimesheetNewDetailsScreen extends StatefulWidget {
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
  final String positionId;
  final String companyId;

  CandidateTimesheetNewDetailsScreen({
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
    this.positionId,
    this.companyId,
  });

  @override
  _CandidateTimesheetNewDetailsScreenState createState() =>
      _CandidateTimesheetNewDetailsScreenState();
}

class _CandidateTimesheetNewDetailsScreenState
    extends State<CandidateTimesheetNewDetailsScreen> {
  bool _updated = false;
  bool _fetching = false;

  String _shiftStart = TimesheetTimeKey[TimesheetTime.Start];
  String _breakStart = TimesheetTimeKey[TimesheetTime.BreakStart];
  String _breakEnd = TimesheetTimeKey[TimesheetTime.BreakEnd];
  String _shiftEnd = TimesheetTimeKey[TimesheetTime.End];

  bool _withBreak = true;
  bool _hours;
  String _error;

  Map<String, DateTime> _times = Map();

  @override
  void initState() {
    _times = {
      _shiftStart: widget.shiftStart,
      _breakStart: widget.breakStart,
      _breakEnd: widget.breakEnd,
      _shiftEnd: widget.shiftEnd
    };

    if (widget.status == 5) {
      _hours = true;
    }

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
      setState(() {
        _error = null;
      });
      Map<String, String> body;

      if (_hours) {
        if (!_withBreak) {
          _times[_breakEnd] = _times[_breakStart];
        }

        body =
            _times.map((key, value) => MapEntry(key, value.toUtc().toString()));
        body['hours'] = 'true';
      } else {
        body = {'hours': 'false'};
      }

      bool result = await timesheetService.submitTimesheet(widget.id, body);

      setState(() => _updated = result);
    } catch (e) {
      print(e);

      setState(() {
        _error = e;
      });
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
          // SvgPicture.asset("images/icons/ic_building"),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              translate('button.change'),
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

  Widget _buildTimesForm() {
    return Column(
      children: [
        GroupTitle(title: translate('group.title.times')),
        DetailsRecord(
          label: translate('field.shift_start_time'),
          value: DateFormat.jm().format(_times[_shiftStart]),
          button: (widget.status == 4 || widget.status == 5) && !_updated
              ? _buildChangeButton(
                  _times[_shiftStart],
                  _shiftStart,
                )
              : null,
        ),
        _withBreak || (widget.status != 4 && widget.status != 5)
            ? DetailsRecord(
                label: translate('field.break_start_time'),
                value: _times[_breakStart] == null
                    ? '-'
                    : DateFormat.jm().format(_times[_breakStart]),
                button: (widget.status == 4 || widget.status == 5) && !_updated
                    ? _buildChangeButton(
                        _times[_breakStart],
                        _breakStart,
                      )
                    : null,
              )
            : SizedBox(),
        _withBreak || (widget.status != 4 && widget.status != 5)
            ? DetailsRecord(
                label: translate('field.break_end_time'),
                value: _times[_breakEnd] == null
                    ? '-'
                    : DateFormat.jm().format(_times[_breakEnd]),
                button: (widget.status == 4 || widget.status == 5) && !_updated
                    ? _buildChangeButton(
                        _times[_breakEnd],
                        _breakEnd,
                      )
                    : null,
              )
            : SizedBox(),
        DetailsRecord(
          label: translate('field.shift_end_time'),
          value: _times[_shiftEnd] == null
              ? '-'
              : DateFormat.jm().format(_times[_shiftEnd]),
          button: (widget.status == 4 || widget.status == 5) && !_updated
              ? _buildChangeButton(
                  _times[_shiftEnd],
                  _shiftEnd,
                )
              : null,
        ),
        (widget.status == 4 || widget.status == 5) && !_updated
            ? Row(
                children: [
                  Container(
                    child: Text(translate('timesheet.break')),
                    margin: const EdgeInsets.only(left: 8.0),
                  ),
                  Switch(
                    value: _withBreak,
                    onChanged: (bool newValue) {
                      setState(() {
                        _withBreak = newValue;
                      });
                    },
                  ),
                ],
              )
            : SizedBox(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var dateString = 'April 20, 2020';
    DateFormat format = new DateFormat("MMMM dd, yyyy");
    var shiftEnddate = format.parse(dateString);
    TimesheetService timesheetService = Provider.of<TimesheetService>(context);
    SkillActivityService skillActivityService =
        Provider.of<SkillActivityService>(context);

    return Scaffold(
      appBar: getCandidateAppBar(
        translate('page.title.timesheet'),
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: Text(
                  'General Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GeneralInformationWidget(
                      imageIcon: 'images/icons/ic_profile.svg',
                      name: 'SUPERVISIOR',
                      value: widget.clientContact,
                    ),
                    GeneralInformationWidget(
                        imageIcon: 'images/icons/ic_building.svg',
                        name: 'COMPANY',
                        value: widget.clientContact),
                    GeneralInformationWidget(
                        imageIcon: 'images/icons/ic_work.svg',
                        name: 'JOBSITE',
                        value: widget.jobsite),
                    GeneralInformationWidget(
                        imageIcon: 'images/icons/ic_support.svg',
                        name: 'POSISTION',
                        value: widget.position),
                    GeneralInformationWidget(
                        imageIcon: 'images/icons/ic_calendar.svg',
                        name: 'SHIFTDATE',
                        value:
                            "${widget.shiftDate.month}:${widget.shiftDate.day}:${widget.shiftDate.year}"),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Time', style: TextStyle(fontWeight: FontWeight.w500)),
                    Container(
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TimeWidgetPage()),
                              );
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TimeWidgetPage()),
                              );
                            },
                            child: Text(
                              'ADD',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Activity',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Container(
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActivityWidgetPage()),
                              );
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActivityWidgetPage()),
                              );
                            },
                            child: Text(
                              'ADD',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: new BorderRadius.circular(8.0),
                ),
                width: 380,
                height: 35,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Submit'),
                ),
              ),
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
              DetailsRecord(
                label: translate('field.shift_date'),
                value: DateFormat('dd/MM/yyyy').format(widget.shiftDate),
              ),
              widget.status == 4 && !_updated
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _hours = true;
                        });
                      },
                      child: Text(translate('button.times_only'))),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _hours = false;
                        });
                      },
                      child: Text(translate('button.peicework')))
                ],
              )
                  : SizedBox(),
              _hours == true || widget.status != 4
                  ? this._buildTimesForm()
                  : SizedBox(),
              _hours == false || widget.status != 4
                  ? SkillActivityTable(
                  hasActions: (widget.status == 4 || widget.status == 5) &&
                      !_updated,
                  service: skillActivityService,
                  skill: widget.positionId,
                  timesheet: widget.id,
                  companyId: widget.companyId)
                  : SizedBox(),
              GroupTitle(title: translate('group.title.job_information')),
              DetailsRecord(
                label: translate('field.jobsite'),
                value: widget.jobsite,
              ),
              DetailsRecord(
                label: translate('field.site_manager'),
                value: widget.clientContact,
              ),
              DetailsRecord(
                label: translate('field.address'),
                value: widget.address,
              ),
              widget.status == 1 && !_updated
                  ? Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Center(
                      child: Text(
                        translate('message.pre_shift_check'),
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
                        label: translate('button.decline'),
                        onPressed: () =>
                            _declinePreShiftCheck(timesheetService),
                        disabled: _fetching,
                        color: Colors.red[400],
                        horizontalPadding: 50,
                      ),
                      FormSubmitButton(
                        label: translate('button.accept'),
                        onPressed: () =>
                            _acceptPreShiftCheck(timesheetService),
                        disabled: _fetching,
                        color: Colors.green[400],
                        horizontalPadding: 50,
                      ),
                    ],
                  ),
                ],
              )
                  : Container(),
              (widget.status == 4 || widget.status == 5) &&
                  !_updated &&
                  _hours != null
                  ? FormSubmitButton(
                label: translate('button.submit'),
                onPressed: () => _submitForm(timesheetService),
                      disabled: _fetching,
                    )
                  : Container(),
              _error != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        _error,
                        style: TextStyle(color: Colors.red[400]),
                      ))
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
