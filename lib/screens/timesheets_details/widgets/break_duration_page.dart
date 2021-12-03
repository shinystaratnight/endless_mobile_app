import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/screens/timesheets_details/widgets/time_duration_widget.dart';

class BreakDurationPage extends StatelessWidget {
  BreakDurationPage({Key key}) : super(key: key);

  final RxString selectedTimeStr = 'Time'.obs;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TimeDurationWidgetPage(),
            ),
          );
        },
        child: Ink(
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
              Obx(
                () => Text(
                  selectedTimeStr.value,
                  style: TextStyle(fontSize: 16, color: AppColors.lightBlack),
                ),
              ),
              SvgPicture.asset(
                "images/icons/ic_time_duration.svg",
                height: 24,
                width: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
