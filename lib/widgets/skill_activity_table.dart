import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/models/skill_activity_model.dart';
import 'package:piiprent/screens/candidate_skill_activity_screen.dart';
import 'package:piiprent/screens/timesheets_details/time_widget_page.dart';
import 'package:piiprent/screens/timesheets_details/widgets/duation_show_widget.dart';
import 'package:piiprent/screens/timesheets_details/widgets/time_add_widget.dart';
import 'package:piiprent/services/skill_activity_service.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:piiprent/widgets/toast.dart';
import 'package:provider/provider.dart';

class SkillActivityTable extends StatefulWidget {
  final bool hasActions;
  final String timesheet;
  final String skill;
  final SkillActivityService service;
  final String companyId;
  final bool isTimeAdded;
  Map<String, DateTime> times;
  final String shiftEnd;

  final int status;
  final String shiftStart;
  final String breakEnd;
  final String breakStart;
  final Function onSubmit;

  SkillActivityTable({
    this.hasActions,
    this.timesheet,
    this.skill,
    this.service,
    this.companyId,
    this.isTimeAdded,
    this.status,
    this.times,
    this.shiftEnd,
    this.shiftStart,
    this.breakEnd,
    this.breakStart,
    this.onSubmit,
  });

  @override
  _SkillActivityTableState createState() => _SkillActivityTableState();
}

class _SkillActivityTableState extends State<SkillActivityTable> {
  final StreamController<List<SkillActivity>> _streamController =
      StreamController();

  bool _fetching = true;
  bool _error;

  @override
  void initState() {
    super.initState();

    getSkillActivities();
  }

  void getSkillActivities() async {
    setState(() {
      _fetching = true;
    });

    try {
      List<SkillActivity> data =
          await widget.service.getSkillActivitiesByTimesheet({
        'timesheet': widget.timesheet,
        'skill': widget.skill,
      });

      setState(() {
        _fetching = false;
        _error = null;
      });

      _streamController.add(data);
    } catch (e) {
      setState(() {
        _error = true;
        _fetching = false;
      });
    }
  }

  void deleteSkillActivity(String id) async {
    setState(() {
      _fetching = true;
    });

    try {
      await widget.service.removeSkillActivity(id);

      getSkillActivities();
    } catch (e) {
      setState(() {
        _fetching = false;
        _error = true;
      });
    }
  }

/*  submitForm(TimesheetService timesheetService, bool isDelete) async {
    if (widget.times.values.contains(null)) {
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
      body = widget.times.map((key, value) =>
          MapEntry(key, isDelete ? null : value.toUtc().toString()));
      if (isDelete == false) {
        body['hours'] = 'true';
      }

      if (isDelete == false) {
        toast('Time and activities submitting');
      }

      bool result = await timesheetService.submitTimesheet(widget.id, body);
      if (result && isDelete) {
        widget.times.forEach((key, value) {
          if (key != widget.shiftStart) {
            if (key == widget.breakStart || key == widget.breakEnd) {
              widget.times[key] = widget.times[widget.shiftStart].add(Duration(hours: 2));
            } else {
              widget.times[key] = null;
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
  }*/

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<SkillActivity> data = snapshot.data;
          return Column(
            children: [
              if (widget.status == 4 || widget.status == 5)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Time',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        //fontSize: 16,
                        fontSize: SizeConfig.heightMultiplier * 3.22,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        color: AppColors.lightBlack,
                      ),
                    ),
                    //if (widget.status == 4 || widget.status == 5)
                    if (widget.status == 4)
                      widget.times[widget.shiftEnd] != null
                          ? Row(mainAxisSize: MainAxisSize.min, children: [
                              Padding(
                                //padding: const EdgeInsets.all(3.0),
                                padding: EdgeInsets.all(
                                    SizeConfig.heightMultiplier * 0.44),
                                child: InkWell(
                                  onTap: () async {
                                    var result = await Get.to(() =>
                                        TimeSheetWidgetPage(widget.times));
                                    if (result is Map) {
                                      setState(() {
                                        widget.times = result;
                                        print('updateTimes: ${widget.times}');
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
                                  onTap: () {
                                    // TimesheetService timesheetServices;
                                    TimesheetService timesheetService = Provider.of<TimesheetService>(context);
                                    widget.onSubmit(timesheetService, true);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: AppColors.red,
                                    //size: 18,
                                    size: SizeConfig.heightMultiplier * 2.64,
                                  ),
                                ),
                              )
                            ])
                          : data.length == 0
                              ? InkWell(
                                  onTap: () async {
                                    var result = await Get.to(() =>
                                        TimeSheetWidgetPage(widget.times));
                                    if (result is Map) {
                                      setState(() {
                                        widget.times = result;
                                        print('results: ${widget.times}');
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      // horizontal: 8.0,
                                      // vertical: 3,
                                      horizontal:
                                          SizeConfig.widthMultiplier * 1.95,
                                      vertical:
                                          SizeConfig.heightMultiplier * 0.44,
                                    ),
                                    child: Text(
                                      'ADD',
                                      style: TextStyle(
                                        color: AppColors.blue,
                                        fontWeight: FontWeight.w500,
                                        //fontSize: 14,
                                        fontSize:
                                            SizeConfig.heightMultiplier * 2.05,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                  ],
                ),
              if (widget.times[widget.shiftEnd] != null)
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
                          fontSize: SizeConfig.heightMultiplier * 3.22,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          color: AppColors.lightBlack,
                        ),
                      ),
                    SizedBox(
                      //size: 18,
                      height: SizeConfig.heightMultiplier * 1.5,
                    ),
                    TimeAddWidget(
                        'START TIME', widget.times[widget.shiftStart]),
                    TimeAddWidget('END TIME', widget.times[widget.shiftEnd]),
                    DurationShowWidget(
                        'BREAK TIME',
                        widget.times[widget.breakEnd]
                            .difference(widget.times[widget.breakStart]))
                  ],
                ),
              SizedBox(
                //height: 24,
                height: SizeConfig.heightMultiplier * 3.51,
              ),
              _fetching
                  ? Container(
                      margin: EdgeInsets.symmetric(
                        //vertical: 20,
                        vertical: SizeConfig.heightMultiplier * 2.93,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.hasActions
                            ? (data.length == 0 && !widget.isTimeAdded)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Activity',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          //fontSize: 16,
                                          fontSize:
                                              SizeConfig.heightMultiplier *
                                                  2.34,
                                          fontFamily:
                                              GoogleFonts.roboto().fontFamily,
                                          color: AppColors.lightBlack,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CandidateSkillActivityScreen(
                                                      skill: widget.skill,
                                                      timesheet:
                                                          widget.timesheet,
                                                      companyId:
                                                          widget.companyId),
                                            ),
                                          )
                                              .then((dynamic result) {
                                            if (result == true) {
                                              getSkillActivities();
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            // horizontal: 8.0,
                                            // vertical: 3,
                                            horizontal:
                                                SizeConfig.widthMultiplier *
                                                    1.95,
                                            vertical:
                                                SizeConfig.heightMultiplier *
                                                    0.44,
                                          ),
                                          child: Text(
                                            'ADD',
                                            style: TextStyle(
                                              color: AppColors.blue,
                                              fontWeight: FontWeight.w500,
                                              //fontSize: 14,
                                              fontSize:
                                                  SizeConfig.heightMultiplier *
                                                      2.05,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : SizedBox()
                            : SizedBox(),
                        SizedBox(
                          //height: 16,
                          height: SizeConfig.heightMultiplier,
                        ),
                        data.length != 0
                            ? Text(
                                "Activities",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  //fontSize: 16,
                                  fontSize: SizeConfig.heightMultiplier * 3.22,
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                  color: AppColors.lightBlack,
                                ),
                              )
                            : SizedBox(),
                        SizedBox(height: 10),
                        ListView.builder(
                          itemBuilder: (context, index) => Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data[index].worktype != null
                                      ? data[index].worktype.name == null
                                          ? ""
                                          : data[index].worktype.name(
                                              localizationDelegate
                                                  .currentLocale)
                                      : "",
                                  style: TextStyle(
                                    color: AppColors.lightBlack,
                                    //fontSize: 14,
                                    fontSize:
                                        SizeConfig.heightMultiplier * 2.05,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                widget.hasActions
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(
                                              //3.0,
                                              SizeConfig.heightMultiplier *
                                                  0.44,
                                            ),
                                            child: InkWell(
                                              onTap: () async {
                                                Navigator.of(context)
                                                    .push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CandidateSkillActivityScreen(
                                                            timesheet: widget
                                                                .timesheet,
                                                            skill: widget.skill,
                                                            companyId: widget
                                                                .companyId,
                                                            skillActivityModel:
                                                                data[index]),
                                                  ),
                                                )
                                                    .then((dynamic result) {
                                                  if (result == true) {
                                                    getSkillActivities();
                                                  }
                                                });
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: AppColors.green,
                                                //size: 18,
                                                size: SizeConfig
                                                        .heightMultiplier *
                                                    2.85,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            //width: 16,
                                            width: SizeConfig.widthMultiplier *
                                                3.89,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              // vertical: 3.0,
                                              vertical:
                                                  SizeConfig.heightMultiplier *
                                                      0.44,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                if (!_fetching) {
                                                  deleteSkillActivity(
                                                      data[index].id);
                                                }
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: AppColors.red,
                                                //size: 18,
                                                size: SizeConfig
                                                        .heightMultiplier *
                                                    2.85,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox()
                              ],
                            ),
                            SizedBox(
                              //height: 20,
                              height: SizeConfig.heightMultiplier,
                            ),
                            TimeAddWidget(
                                'AMOUNT', data[index].value.toString())
                          ]),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(),
                          itemCount: data.length,
                        ),
                        SizedBox(
                          //height: 16,
                          height: SizeConfig.heightMultiplier * 2.34,
                        ),
                        _error != null
                            ? Padding(
                                padding: EdgeInsets.only(
                                  //bottom: 8.0,
                                  bottom: SizeConfig.heightMultiplier * 1.17,
                                ),
                                child: Text(
                                  translate('message.has_error'),
                                  style: TextStyle(
                                    color: Colors.red[400],
                                    fontSize:
                                        SizeConfig.heightMultiplier * 2.34,
                                  ),
                                ),
                              )
                            : SizedBox()
                      ],
                    )
            ],
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
