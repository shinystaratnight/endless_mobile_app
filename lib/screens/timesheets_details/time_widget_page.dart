import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/helpers/functions.dart';
import 'package:piiprent/screens/timesheets_details/selected_time_details.dart';
import 'package:piiprent/screens/timesheets_details/widgets/date_picker_box_widget.dart';
import 'package:piiprent/screens/timesheets_details/widgets/time_hint_widget.dart';

import 'widgets/break_duration_page.dart';
import 'widgets/time_picker_box_widget.dart';

class TimeSheetWidgetPage extends StatelessWidget {
  TimeSheetWidgetPage(this.selectedTimeDetails, {Key key}) : super(key: key);
  SelectedTimeDetails selectedTimeDetails;

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
                  initialDate:
                      stringDateToDateTime(selectedTimeDetails.startDateStr),
                  onDateSelected: (String startDate) {
                    selectedTimeDetails.startDateStr = startDate;
                  },
                ),
                SizedBox(width: 16),
                TimePickerBoxWidget(
                  initialTime:
                      stringTimeToTimeOfDay(selectedTimeDetails.startTimeStr),
                  onTimeSelected: (String startTime) {
                    selectedTimeDetails.startTimeStr = startTime;
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
                  initialDate:
                      stringDateToDateTime(selectedTimeDetails.endDateStr),
                  onDateSelected: (String endDate) {
                    selectedTimeDetails.endDateStr = endDate;
                  },
                ),
                SizedBox(width: 16),
                TimePickerBoxWidget(
                  initialTime:
                      stringTimeToTimeOfDay(selectedTimeDetails.endTimeStr),
                  onTimeSelected: (String endTime) {
                    selectedTimeDetails.endTimeStr = endTime;
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
