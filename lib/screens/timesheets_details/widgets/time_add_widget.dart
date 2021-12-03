import 'package:flutter/material.dart';
import 'package:piiprent/helpers/colors.dart';

class TimeAddWidget extends StatelessWidget {
  const TimeAddWidget(this.hintText, this.datetimeVal, {Key key})
      : super(key: key);
  final String hintText;
  final String datetimeVal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 19.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.circle,
            size: 5,
            color: Colors.blue,
          ),
          SizedBox(
            width: 6,
          ),
          Expanded(
            flex: 2,
            child: Text(
              hintText,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              children: [
                Text(
                  datetimeVal,
                  style: TextStyle(
                    color: AppColors.lightBlack,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
