import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/screens/timesheets_details/time_widget_page.dart';

class TimeDurationWidgetPage extends StatefulWidget {
  final String title;

  TimeDurationWidgetPage({Key key, this.title}) : super(key: key);

  @override
  State<TimeDurationWidgetPage> createState() => _TimeDurationWidgetPageState();
}

class _TimeDurationWidgetPageState extends State<TimeDurationWidgetPage> {
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // hourMinute12H(),
                // hourMinute15Interval(),
                hourMinuteSecond(),
                // hourMinute12HCustomStyle(),
                new Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: new Text(
                    _dateTime.hour.toString().padLeft(2, '0') +
                        ':' +
                        _dateTime.minute.toString().padLeft(2, '0')
                    // ':' +
                    // _dateTime.second.toString().padLeft(2, '0')
                    ,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: InkWell(
                          child: Text(
                            'cancel',
                            style: TextStyle(
                                color: AppColors.darkBlue, fontSize: 18),
                          ),
                          onTap: () {
                            Get.to(() => TimeSheetWidgetPage());
                          },
                        ),
                      ),
                      Container(
                        child: InkWell(
                          child: Text(
                            'ok',
                            style: TextStyle(
                                fontSize: 18, color: AppColors.darkBlue),
                          ),
                          onTap: () {
                            Get.to(() => TimeSheetWidgetPage());
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget hourMinute12H() {
    return new TimePickerSpinner(
      normalTextStyle: TextStyle(fontSize: 24, color: Colors.orange),
      highlightedTextStyle: TextStyle(fontSize: 30, color: Colors.blueAccent),
      is24HourMode: false,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }

  Widget hourMinuteSecond() {
    return new TimePickerSpinner(
      normalTextStyle: TextStyle(fontSize: 24, color: AppColors.grey),
      highlightedTextStyle: TextStyle(fontSize: 30, color: AppColors.darkBlue),
      isShowSeconds: true,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }

  Widget hourMinute15Interval() {
    return new TimePickerSpinner(
      normalTextStyle: TextStyle(fontSize: 24, color: Colors.black),
      highlightedTextStyle: TextStyle(fontSize: 30, color: Colors.blueAccent),
      spacing: 40,
      minutesInterval: 15,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }

  Widget hourMinute12HCustomStyle() {
    return new TimePickerSpinner(
      is24HourMode: false,
      normalTextStyle: TextStyle(fontSize: 24, color: Colors.black),
      highlightedTextStyle: TextStyle(fontSize: 30, color: Colors.blueAccent),
      spacing: 50,
      itemHeight: 80,
      isForce2Digits: true,
      minutesInterval: 15,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
}
