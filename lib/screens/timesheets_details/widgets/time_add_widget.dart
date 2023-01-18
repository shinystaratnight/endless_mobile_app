import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/helpers/functions.dart';
import 'package:piiprent/widgets/size_config.dart';

class TimeAddWidget extends StatelessWidget {
   TimeAddWidget(this.hintText, this.dateTime, {this.width,Key key})
      : super(key: key);
  final String hintText;
  final dynamic dateTime;
  double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.only(
          //bottom: 16.0,
          bottom:SizeConfig.heightMultiplier*1.2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width:width ??  Get.width * 0.18,
            // decoration: BoxDecoration(border: Border.all()),
            child: Text(
              hintText + ': ',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 12,
                // fontSize: SizeConfig.heightMultiplier*1.76,
              ),
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
