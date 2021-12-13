import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/screens/timesheets_details/selected_time_details.dart';
import 'package:piiprent/screens/timesheets_details/widgets/time_add_widget.dart';
import 'package:piiprent/services/skill_activity_service.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:piiprent/widgets/group_title.dart';
import 'package:piiprent/widgets/skill_activity_table.dart';
import 'package:provider/provider.dart';

import '../candidate_skill_activity_screen.dart';
import 'time_widget_page.dart';
import 'widgets/duation_show_widget.dart';
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
  final String companyStr;

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
    this.companyStr,
  });

  @override
  _CandidateTimesheetNewDetailsScreenState createState() =>
      _CandidateTimesheetNewDetailsScreenState();
}

class _CandidateTimesheetNewDetailsScreenState
    extends State<CandidateTimesheetNewDetailsScreen> {
  bool _updated = false;
  bool _fetching = false;

  SelectedTimeDetails selectedTimeDetails = SelectedTimeDetails();

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
    DateTime _breakTime;
    if (widget.shiftStart != null)
      _breakTime =
          widget.breakStart ?? widget.shiftStart.add(Duration(hours: 2));

    _times = {
      _shiftStart: widget.shiftStart,
      _breakStart: _breakTime,
      _breakEnd: widget.breakEnd ?? _breakTime,
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

      // if (_hours) {
      // if (!_withBreak) {
      //   _times[_breakEnd] = _times[_breakStart];
      // }

      body =
          _times.map((key, value) => MapEntry(key, value.toUtc().toString()));
      body['hours'] = 'true';
      // } else {
      //   body = {'hours': 'false'};
      // }

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
    TimesheetService timesheetService = Provider.of<TimesheetService>(context);
    SkillActivityService skillActivityService =
        Provider.of<SkillActivityService>(context);

    // List<SkillActivity> data = snapshot.data;
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Information',
              style: TextStyle(
                fontSize: 16,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w500,
                color: AppColors.lightBlack,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            GeneralInformationWidget(
              imageIcon: 'images/icons/ic_profile.svg',
              name: 'SUPERVISIOR',
              value: widget.clientContact,
            ),
            GeneralInformationWidget(
                imageIcon: 'images/icons/ic_building.svg',
                name: 'COMPANY',
                value: widget.companyStr),
            GeneralInformationWidget(
                imageIcon: 'images/icons/ic_work.svg',
                name: 'JOBSITE',
                value: widget.jobsite),
            GeneralInformationWidget(
                imageIcon: 'images/icons/ic_building.svg',
                name: 'ADDRESS',
                value: widget.address),
            GeneralInformationWidget(
                imageIcon: 'images/icons/ic_support.svg',
                name: 'POSITION',
                value: widget.position),
            GeneralInformationWidget(
              imageIcon: 'images/icons/ic_calendar.svg',
              name: 'SHIFT DATE',
              value: DateFormat('MMM dd, yyyy').format(widget.shiftDate),
            ),
            SizedBox(
              height: 25,
            ),
            if (widget.status != 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Time',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      color: AppColors.lightBlack,
                    ),
                  ),
                  if (widget.status == 4 && !_updated)
                    (_times[_shiftEnd] != null)
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: InkWell(
                                  onTap: () async {
                                    var result = await Get.to(
                                        () => TimeSheetWidgetPage(_times));
                                    if (result is Map) {
                                      setState(() {
                                        _hours = true;
                                        _times = result;
                                        print('updateTimes: $_times');
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: AppColors.green,
                                    size: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3.0,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // todo call delete function
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: AppColors.red,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : InkWell(
                            onTap: () async {
                              var result = await Get.to(
                                  () => TimeSheetWidgetPage(_times));
                              if (result is Map) {
                                setState(() {
                                  _times = result;
                                  _hours = true;
                                  print('results: $_times');
                                });
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.blue,
                                    size: 12,
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  'ADD',
                                  style: TextStyle(
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                ],
              ),
            SizedBox(
              height: 18,
            ),
            if (_times[_shiftEnd] != null)
              Column(
                children: [
                  TimeAddWidget('START TIME', _times[_shiftStart]),
                  TimeAddWidget('END TIME', _times[_shiftEnd]),
                  DurationShowWidget('BREAK TIME',
                      _times[_breakEnd].difference(_times[_breakStart]))
                ],
              ),
            SizedBox(
              height: 24,
            ),
            //Activitiy start
            if (widget.status == 4 && !_updated)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Activity',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      color: AppColors.lightBlack,
                    ),
                  ),
                  if (widget.status == 4 && !_updated)
                    (_times[_shiftEnd] != null)
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CandidateSkillActivityScreen(),
                                          ),
                                        )
                                        .then((dynamic result) {});
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: AppColors.green,
                                    size: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3.0,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // todo call delete function
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: AppColors.red,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CandidateSkillActivityScreen(),
                                    ),
                                  )
                                  .then((dynamic result) {});

                              // if (result is Map) {
                              //   setState(() {
                              //     _times = result;
                              //     _hours = true;
                              //     print('results: $_times');
                              //   });
                              // }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.blue,
                                    size: 12,
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  'ADD',
                                  style: TextStyle(
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                ],
              ),
            SizedBox(
              height: 18,
            ),
            if (_times[_shiftEnd] != null)
              widget.status == 4 && !_updated
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ElevatedButton(
                        //     onPressed: () {
                        //       setState(() {
                        //         _hours = false;
                        //       });
                        //     },
                        //     child: Text(translate('button.peicework')))
                      ],
                    )
                  : SizedBox(),
            _hours == false || widget.status != 4
                ? SkillActivityTable(
                    hasActions:
                        (widget.status == 4 || widget.status == 5) && !_updated,
                    service: skillActivityService,
                    skill: widget.positionId,
                    timesheet: widget.id,
                    companyId: widget.companyId)
                : SizedBox(),
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
                ? SizedBox(
                    width: double.infinity,
                    child: FormSubmitButton(
                      label: translate('button.submit'),
                      onPressed: () => _submitForm(timesheetService),
                      disabled: _fetching,
                    ),
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
    );
  }
}
