import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/helpers/functions.dart';
import 'package:piiprent/screens/timesheets_details/selected_time_details.dart';
import 'package:piiprent/screens/timesheets_details/widgets/date_picker_box_widget.dart';
import 'package:piiprent/screens/timesheets_details/widgets/time_hint_widget.dart';

import '../../constants.dart';
import 'widgets/break_duration_page.dart';
import 'widgets/time_picker_box_widget.dart';

class TimeSheetWidgetPage extends StatelessWidget {
  TimeSheetWidgetPage(this.selectedTimeDetails, {this.times, Key key})
      : super(key: key);
  SelectedTimeDetails selectedTimeDetails;
  Map<String, DateTime> times;
  String _shiftStart = TimesheetTimeKey[TimesheetTime.Start];
  String _breakStart = TimesheetTimeKey[TimesheetTime.BreakStart];
  String _breakEnd = TimesheetTimeKey[TimesheetTime.BreakEnd];
  String _shiftEnd = TimesheetTimeKey[TimesheetTime.End];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time'),
        centerTitle: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_left,
                size: 36.0,
              ),
              onPressed: () {
                Get.back(result: context);
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
              size: 26.0,
            ),
            onPressed: () {
              Get.back(result: selectedTimeDetails);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            TimeHintWidget('START TIME'),
            SizedBox(height: 12),
            Row(
              children: [
                DatePickerBoxWidget(
                  initialDate: times[_shiftStart],
                  onDateSelected: (DateTime startDate) {
                    selectedTimeDetails.startDateStr = startDate.toString();
                    selectedTimeDetails.startDateTime = startDate;

                    DateTime _dateTime = DateTime(
                      startDate.year,
                      startDate.month,
                      startDate.day,
                      times[_shiftStart].hour,
                      times[_shiftStart].minute,
                    );
                    times[_shiftStart] = _dateTime;
                    print('initStartDate:: ${times[_shiftStart]}');
                  },
                ),
                SizedBox(width: 16),
                TimePickerBoxWidget(
                  initialDateTime: times[_shiftStart],
                  onTimeSelected: (DateTime startTime) {
                    selectedTimeDetails.startTimeStr = startTime.toString();
                    selectedTimeDetails.startDateTime = startTime;

                    DateTime _dateTime = DateTime(
                      times[_shiftStart].year,
                      times[_shiftStart].month,
                      times[_shiftStart].day,
                      startTime.hour,
                      startTime.minute,
                    );
                    times[_shiftStart] = _dateTime;
                    print('initStartDate:: ${times[_shiftStart]}');
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            TimeHintWidget('END TIME'),
            SizedBox(height: 12),
            Row(
              children: [
                DatePickerBoxWidget(
                  initialDate: times[_shiftEnd],
                  onDateSelected: (DateTime endDate) {
                    selectedTimeDetails.endDateStr = endDate.toString();
                    DateTime _dateTime = DateTime(
                      endDate.year,
                      endDate.month,
                      endDate.day,
                      times[_shiftEnd].hour,
                      times[_shiftEnd].minute,
                    );
                    times[_shiftEnd] = _dateTime;
                    print('_shiftEndDate:: ${times[_shiftEnd]}');
                  },
                ),
                SizedBox(width: 16),
                TimePickerBoxWidget(
                  initialDateTime: times[_shiftEnd],
                  onTimeSelected: (DateTime endTime) {
                    selectedTimeDetails.endTimeStr = endTime.toString();

                    DateTime _dateTime = DateTime(
                      times[_shiftEnd].year,
                      times[_shiftEnd].month,
                      times[_shiftEnd].day,
                      endTime.hour,
                      endTime.minute,
                    );
                    times[_shiftEnd] = _dateTime;
                    print('_shiftEndTime:: ${times[_shiftEnd]}');
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            TimeHintWidget('BREAK TIME'),
            SizedBox(height: 12),
            Row(
              children: [
                BreakDurationPage(
                  initialTime:
                      stringBreakTimeToTimeOfDay(selectedTimeDetails.breakTime),
                  onTimeSelected: (String breakTime) {
                    selectedTimeDetails.breakTime = breakTime;
                  },
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
            SizedBox(height: 40),
            Container(
              width: double.infinity,
              child: MaterialButton(
                onPressed: () {
                  Get.back(result: selectedTimeDetails);
                },
                height: 40,
                child: Text(
                  'SUBMIT',
                  style: TextStyle(
                    fontSize: 14,
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
}
