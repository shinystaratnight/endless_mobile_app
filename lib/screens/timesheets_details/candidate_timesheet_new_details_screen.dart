import 'package:flutter/material.dart';
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
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:piiprent/widgets/skill_activity_table.dart';
import 'package:provider/provider.dart';

import '../../widgets/toast.dart';
import 'time_widget_page.dart';
import 'widgets/duation_show_widget.dart';
import 'widgets/timesheet_general_info_widget.dart';

class CandidateTimesheetNewDetailsScreen extends StatefulWidget {
  final String position;
  final String jobsite;
  final String name;
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
    this.name,
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

  _submitForm(TimesheetService timesheetService, bool isDelete) async {
    if (_times.values.contains(null)) {
      //Get.snackbar("Select Time", '');
      toast("Select Time");
      return;
    }

    try {
      setState(() => _fetching = true);
      setState(() {
        _error = null;
      });
      Map<String, String> body;
      body = _times.map((key, value) =>
          MapEntry(key, isDelete ? null : value.toUtc().toString()));
      if (isDelete == false) {
        body['hours'] = 'true';
      }

      if (isDelete == false) {
        toast('Time and activities submitting');
      }

      bool result = await timesheetService.submitTimesheet(widget.id, body);
      if (result && isDelete) {
        _times.forEach((key, value) {
          if (key != _shiftStart) {
            if (key == _breakStart || key == _breakEnd) {
              _times[key] = _times[_shiftStart].add(Duration(hours: 2));
            } else {
              _times[key] = null;
            }
          }
        });
      }
      setState(() => _updated = result);
      Get.back();
    } catch (e) {
      print(e);
      // Get.snackbar(e.toString(), '');
      setState(() {
        _error = e;
      });
    } finally {
      setState(() => _fetching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    TimesheetService timesheetService = Provider.of<TimesheetService>(context);
    SkillActivityService skillActivityService =
        Provider.of<SkillActivityService>(context);
    print('breakstart: $_breakStart');
    print('breakend: $_breakEnd');
    print(
        'breakstart - breakend: ${_times[_breakStart].difference(_times[_breakEnd])}');
    // List<SkillActivity> data = snapshot.data;
    return Scaffold(
      appBar: getCandidateAppBar(
        translate('page.title.timesheet'),
        context,
        showNotification: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                //size: 36.0,
                size: SizeConfig.heightMultiplier * 5.27,
              ),
              onPressed: () {
                Navigator.pop(context, _updated);
              },
            );
          },
        ),
        isPadding: true
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Information',
              style: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 3.22,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w500,
                color: AppColors.lightBlack,
              ),
            ),
            SizedBox(
              //height: 12,
              height: SizeConfig.heightMultiplier * 1.76,
            ),
            GeneralInformationWidget(
              // imageIcon: 'images/icons/ic_profile.svg',
              name: 'SUPERVISIOR',
              value: widget.name,
              width: Get.width * 0.65,
            ),
            GeneralInformationWidget(
              // imageIcon: 'images/icons/ic_building.svg',
              name: 'COMPANY',
              value: widget.companyStr,
            ),
            // GeneralInformationWidget(
            //     // imageIcon: 'images/icons/ic_work.svg',
            //     name: 'JOBSITE',
            //     value: widget.jobsite),
            GeneralInformationWidget(
              // imageIcon: 'images/icons/ic_building.svg',
              name: 'ADDRESS',
              value: widget.address,
            ),
            GeneralInformationWidget(
              // imageIcon: 'images/icons/ic_support.svg',
              name: 'POSITION',
              value: widget.position,
            ),
            GeneralInformationWidget(
              // imageIcon: 'images/icons/ic_calendar.svg',
              name: 'SHIFT DATE',
              value: DateFormat('MMM dd, yyyy').format(widget.shiftDate),
            ),
            SizedBox(
              //height: 12,
              height: SizeConfig.heightMultiplier * 1.75,
            ),
            if (widget.status == 4 || widget.status == 5)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Time',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      //fontSize: 16,
                      fontSize: SizeConfig.heightMultiplier *  3.22,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      color: AppColors.lightBlack,
                    ),
                  ),
                  //if (widget.status == 4 || widget.status == 5)
                  if (widget.status == 4)
                    _times[_shiftEnd] != null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                //padding: const EdgeInsets.all(3.0),
                                padding: EdgeInsets.all(
                                    SizeConfig.heightMultiplier * 0.44),
                                child: InkWell(
                                  onTap: () async {
                                    var result = await Get.to(
                                        () => TimeSheetWidgetPage(_times));
                                    if (result is Map) {
                                      setState(() {
                                        _times = result;
                                        print('updateTimes: $_times');
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: AppColors.green,
                                    //size: 18,
                                    size: SizeConfig.heightMultiplier * 2.64,
                                  ),
                                ),
                              ),
                              SizedBox(
                                //width: 16,
                                width: SizeConfig.widthMultiplier * 3.89,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  //vertical: 3.0,
                                  vertical: SizeConfig.heightMultiplier * 0.44,
                                ),
                                child: InkWell(
                                  onTap: () =>
                                      _submitForm(timesheetService, true),
                                  child: Icon(
                                    Icons.delete,
                                    color: AppColors.red,
                                    //size: 18,
                                    size: SizeConfig.heightMultiplier * 2.64,
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
                                  print('results: $_times');
                                });
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                // horizontal: 8.0,
                                // vertical: 3,
                                horizontal: SizeConfig.widthMultiplier * 1.95,
                                vertical: SizeConfig.heightMultiplier * 0.44,
                              ),
                              child: Text(
                                'ADD',
                                style: TextStyle(
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.w500,
                                  //fontSize: 14,
                                  fontSize: SizeConfig.heightMultiplier * 2.05,
                                ),
                              ),
                            ),
                          ),
                ],
              ),
            if (_times[_shiftEnd] != null)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!(widget.status == 4 || widget.status == 5))
                  Text(
                    'Time',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      //fontSize: 16,
                      fontSize: SizeConfig.heightMultiplier *  3.22,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      color: AppColors.lightBlack,
                    ),
                  ),
                  SizedBox(
                    //size: 18,
                    height: SizeConfig.heightMultiplier * 1.5,
                  ),
                  TimeAddWidget('START TIME', _times[_shiftStart]),
                  TimeAddWidget('END TIME', _times[_shiftEnd]),
                  DurationShowWidget('BREAK TIME',
                      _times[_breakEnd].difference(_times[_breakStart]))
                ],
              ),
            SizedBox(
              //height: 24,
              height: SizeConfig.heightMultiplier * 3.51,
            ),
            SkillActivityTable(
                hasActions: widget.status == 4,
                service: skillActivityService,
                skill: widget.positionId,
                timesheet: widget.id,
                companyId: widget.companyId),

            widget.status == 1 && !_updated
                ? Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          //bottom: 8.0,
                          bottom: SizeConfig.heightMultiplier * 1.17,
                        ),
                        child: Center(
                          child: Text(
                            translate('message.pre_shift_check'),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: SizeConfig.heightMultiplier * 2.34,
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
                            //horizontalPadding: 50,
                            horizontalPadding:
                                SizeConfig.widthMultiplier * 12.17,
                          ),
                          FormSubmitButton(
                            label: translate('button.accept'),
                            onPressed: () =>
                                _acceptPreShiftCheck(timesheetService),
                            disabled: _fetching,
                            color: Colors.green[400],
                            //horizontalPadding: 50,
                            horizontalPadding:
                                SizeConfig.widthMultiplier * 12.17,
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(),
            widget.status == 4 /*|| widget.status == 5*/
                ? SizedBox(
                    width: double.infinity,
                    child: FormSubmitButton(
                      label: translate('button.submit'),
                      onPressed: () => _submitForm(timesheetService, false),
                      disabled: _fetching,
                    ),
                  )
                : Container(),
            widget.status == 5
                ? Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Approval Pending',
                      style: TextStyle(
                        fontSize: SizeConfig.heightMultiplier * 2.34,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blue,
                      ),
                    ),
                  )
                : Container(),
            _error != null
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      //vertical: 8.0,
                      vertical: SizeConfig.heightMultiplier * 1.17,
                    ),
                    child: Text(
                      _error,
                      style: TextStyle(
                        color: Colors.red[400],
                        fontSize: SizeConfig.heightMultiplier * 2.34,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
