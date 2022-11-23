import 'package:flutter/material.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/helpers/functions.dart';
import 'package:piiprent/widgets/size_config.dart';

class TimeAddWidget extends StatelessWidget {
  const TimeAddWidget(this.hintText, this.dateTime, {Key key})
      : super(key: key);
  final String hintText;
  final dynamic dateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.only(
          //bottom: 16.0,
          bottom:SizeConfig.heightMultiplier*2.34,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            hintText + ': ',
            style: TextStyle(
              color: AppColors.grey,
              //fontSize: 12,
              fontSize: SizeConfig.heightMultiplier*1.76,
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
                  //fontSize: 14,
                  fontSize: SizeConfig.heightMultiplier*2.05,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
