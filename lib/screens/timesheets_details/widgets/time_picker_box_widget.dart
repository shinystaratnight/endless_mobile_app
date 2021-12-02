import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piiprent/helpers/colors.dart';

class TimePickerBoxWidget extends StatelessWidget {
  const TimePickerBoxWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 56,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          border: Border.all(
            width: 1,
            color: AppColors.blueBorder,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Time',
              style: TextStyle(fontSize: 16, color: AppColors.lightBlack),
            ),
            SvgPicture.asset(
              "images/icons/ic_time.svg",
              height: 20,
              width: 18,
            ),
          ],
        ),
      ),
    );
  }
}
