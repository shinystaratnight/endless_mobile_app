import 'package:flutter/material.dart';
import 'package:piiprent/helpers/colors.dart';

import '../../../widgets/size_config.dart';

class DurationShowWidget extends StatelessWidget {
  const DurationShowWidget(this.hintText, this.duration, {Key key})
      : super(key: key);
  final String hintText;
  final Duration duration;

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          hintText + ": ",
          style: TextStyle(
            color: AppColors.grey,
            //fontSize: 12,
            fontSize:SizeConfig.heightMultiplier*1.76,
          ),
        ),
        Row(
          children: [
            Text(
             '${duration.inHours}h ${duration.inMinutes % 60}m',
              style: TextStyle(
                color: AppColors.lightBlack,
                //fontSize: 14,
                fontSize:SizeConfig.heightMultiplier*2.05,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
