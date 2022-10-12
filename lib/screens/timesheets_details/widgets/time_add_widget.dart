import 'package:flutter/material.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/helpers/functions.dart';

class TimeAddWidget extends StatelessWidget {
  const TimeAddWidget(this.hintText, this.dateTime, {Key key})
      : super(key: key);
  final String hintText;
  final dynamic dateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            hintText + ': ',
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 12,
            ),
          ),
          Row(
            children: [
              Text(
                dateTime is DateTime
                    ? formatDateTime(dateTime)
                    : dateTime.toString(),
                style: TextStyle(
                  color: AppColors.lightBlack,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
