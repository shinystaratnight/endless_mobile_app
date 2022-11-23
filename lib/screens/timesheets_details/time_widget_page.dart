import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/screens/timesheets_details/widgets/date_picker_box_widget.dart';
import 'package:piiprent/screens/timesheets_details/widgets/time_hint_widget.dart';

import '../../constants.dart';
import '../../widgets/size_config.dart';
import '../../widgets/toast.dart';
import 'widgets/break_duration_box_widget.dart';
import 'widgets/time_picker_box_widget.dart';

class TimeSheetWidgetPage extends StatefulWidget {
  TimeSheetWidgetPage(this.times, {Key key}) : super(key: key);
  Map<String, DateTime> times;

  @override
  State<TimeSheetWidgetPage> createState() => _TimeSheetWidgetPageState();
}

class _TimeSheetWidgetPageState extends State<TimeSheetWidgetPage> {
  String _shiftStart = TimesheetTimeKey[TimesheetTime.Start];

  String _breakStart = TimesheetTimeKey[TimesheetTime.BreakStart];

  String _breakEnd = TimesheetTimeKey[TimesheetTime.BreakEnd];

  String _shiftEnd = TimesheetTimeKey[TimesheetTime.End];

  Duration breakDuration;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Time',
          style: TextStyle(
            fontSize: SizeConfig.heightMultiplier * 1.34,
          ),
        ),
        centerTitle: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                //size: 36.0,
                size: SizeConfig.heightMultiplier * 5.27,
              ),
              onPressed: () {
                Get.back();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              //size: 26.0,
              size: SizeConfig.heightMultiplier * 3.81,
            ),
            onPressed: () {
              validateInputs();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          // vertical: 20,
          // horizontal: 16,
          vertical: SizeConfig.heightMultiplier * 2.93,
          horizontal: SizeConfig.widthMultiplier * 3.89,
        ),
        child: Column(
          children: [
            TimeHintWidget('START TIME'),
            SizedBox(
              //height: 12,
              height: SizeConfig.heightMultiplier * 1.76,
            ),
            Row(
              children: [
                DatePickerBoxWidget(
                  initialDate: widget.times[_shiftStart],
                  onDateSelected: (DateTime startDate) {
                    DateTime _dateTime = DateTime(
                      startDate.year,
                      startDate.month,
                      startDate.day,
                      widget.times[_shiftStart]?.hour ?? 0,
                      widget.times[_shiftStart]?.minute ?? 0,
                    );
                    widget.times[_shiftStart] = _dateTime;
                  },
                ),
                SizedBox(
                  //width: 16,
                  width: SizeConfig.widthMultiplier * 3.89,
                ),
                TimePickerBoxWidget(
                  initialDateTime: widget.times[_shiftStart],
                  onTimeSelected: (DateTime startTime) {
                    DateTime _dateTime = DateTime(
                      widget.times[_shiftStart]?.year ?? DateTime.now().year,
                      widget.times[_shiftStart]?.month ?? DateTime.now().month,
                      widget.times[_shiftStart]?.day ?? DateTime.now().day,
                      startTime.hour,
                      startTime.minute,
                    );
                    widget.times[_shiftStart] = _dateTime;
                    print('initStartDate:: ${widget.times[_shiftStart]}');
                  },
                ),
              ],
            ),
            SizedBox(
              //height: 16,
              height: SizeConfig.heightMultiplier * 1.34,
            ),
            TimeHintWidget('END TIME'),
            SizedBox(
              //height: 12,
              height: SizeConfig.heightMultiplier * 1.76,
            ),
            Row(
              children: [
                DatePickerBoxWidget(
                  initialDate: widget.times[_shiftEnd],
                  onDateSelected: (DateTime endDate) {
                    DateTime _dateTime = DateTime(
                      endDate.year,
                      endDate.month,
                      endDate.day,
                      widget.times[_shiftEnd]?.hour ?? 0,
                      widget.times[_shiftEnd]?.minute ?? 0,
                    );
                    widget.times[_shiftEnd] = _dateTime;
                    print('_shiftEndDate:: ${widget.times[_shiftEnd]}');
                  },
                ),
                SizedBox(
                  //width: 16,
                  width: SizeConfig.widthMultiplier * 3.89,
                ),
                TimePickerBoxWidget(
                  initialDateTime: widget.times[_shiftEnd],
                  onTimeSelected: (DateTime endTime) {
                    DateTime _dateTime = DateTime(
                      widget.times[_shiftEnd]?.year ?? DateTime.now().year,
                      widget.times[_shiftEnd]?.month ?? DateTime.now().month,
                      widget.times[_shiftEnd]?.day ?? DateTime.now().day,
                      endTime.hour,
                      endTime.minute,
                    );
                    widget.times[_shiftEnd] = _dateTime;
                    print('_shiftEndTime:: ${widget.times[_shiftEnd]}');
                  },
                ),
              ],
            ),
            SizedBox(
              //height: 20,
              height: SizeConfig.heightMultiplier * 2.93,
            ),
            TimeHintWidget('BREAK TIME'),
            SizedBox(
              //height: 12,
              height: SizeConfig.heightMultiplier * 1.76,
            ),
            Row(
              children: [
                BreakDurationBoxWidget(
                  initialTime: calculateBreakDuration(),
                  onTimeSelected: (TimeOfDay breakTime) {
                    breakDuration = Duration(
                      hours: breakTime.hour,
                      minutes: breakTime.minute,
                    );
                  },
                ),
                SizedBox(
                  //width: 16,
                  width: SizeConfig.widthMultiplier * 3.89,
                ),
                Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
            SizedBox(
              //height: 40,
              height:SizeConfig.heightMultiplier*5.86,
            ),
            Container(
              width: double.infinity,
              child: MaterialButton(
                onPressed: () {
                  validateInputs();
                },
                //height: 40,
                height:SizeConfig.heightMultiplier*5.86,
                child: Text(
                  'SUBMIT',
                  style: TextStyle(
                    //fontSize: 14,
                    fontSize:SizeConfig.heightMultiplier*2.05,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                color: AppColors.darkBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100), // <-- Radius
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TimeOfDay calculateBreakDuration() {
    try {
      Duration time =
          widget.times[_breakEnd].difference(widget.times[_breakStart]);
      if (time != Duration.zero) {
        breakDuration = time;
        print(
            'BreakTime:: ${widget.times[_breakEnd]} start ${widget.times[_breakStart]}');
        print('time:: ${time.inHours} ${time.inMinutes % 60}');

        return TimeOfDay(hour: time.inHours, minute: time.inMinutes % 60);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void validateInputs() {
    if (widget.times[_shiftStart] == null) {
      //  Get.snackbar('Start date required', '');
      toast('Start date required');
      return;
    }

    if (widget.times[_shiftStart].hour == 0) {
      //  Get.snackbar('Start date required', '');
      toast('Start time required');
      return;
    }

    if (widget.times[_shiftEnd] == null) {
      //Get.snackbar('End date required', '');
      toast('End date required');
      return;
    }

    if (widget.times[_shiftEnd].hour == 0 &&
        widget.times[_shiftEnd].minute == 0) {
      //  Get.snackbar('Start date required', '');

      print('widget.times[_shiftEnd].hour : ${widget.times[_shiftEnd].hour}');
      toast('End time required');
      return;
    }

    var value = widget.times[_shiftEnd].difference(widget.times[_shiftStart]);

    if (value.isNegative) {
      // Get.snackbar(
      //     'End Time Can not be early then start time', 'Choose End time');
      toast('End time can\'t be earlier than the start time');
      return;
    }

    widget.times[_breakStart] = widget.times[_shiftStart].add(
      Duration(
        hours: 2,
      ),
    );

    if ((widget.times[_breakEnd].hour == 0 &&
            widget.times[_breakEnd].minute == 0) ||
        breakDuration == null) {
      //Get.snackbar('Break time is required', '');
      toast('Break time is required');
      return;
    }

    // value = times[_shiftEnd].difference(times[_breakStart]);
    //
    // if (value.isNegative) {
    //   Get.snackbar('Break at after 2 hours of shift start',
    //       'Shift start - Shift end: ${times[_shiftStart].hour} - ${times[_shiftEnd].hour} ');
    //
    //   return;
    // }

    if (breakDuration != null) {
      widget.times[_breakEnd] = widget.times[_breakStart].add(
        Duration(
          hours: breakDuration.inHours,
          minutes: (breakDuration.inMinutes % 60),
        ),
      );
    }
    var shiftDuration =
        widget.times[_shiftEnd].difference(widget.times[_shiftStart]);
    var breakLength =
        widget.times[_breakEnd].difference(widget.times[_breakStart]);

    print('break length: $breakLength');
    print('shift duration: $shiftDuration');
    if (!(shiftDuration > breakLength)) {
      // Get.snackbar('Break should not Exceed Shift End Time',
      //     'Shift end:${times[_shiftEnd].hour}:${times[_shiftEnd].minute}    Break end: ${times[_breakEnd].hour}:${times[_breakEnd].minute}');
      toast(
          'Break time can\'t be more than or equal to ( ${shiftDuration.toString().split(':')[0]} ) hours');
      return;
    }

    Get.back(result: widget.times);
  }
}
