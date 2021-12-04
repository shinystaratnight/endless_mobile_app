import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:piiprent/helpers/colors.dart';

class TimePickerBoxWidget extends StatelessWidget {
  TimePickerBoxWidget({Key key, this.onTimeSelected, this.initialTime})
      : super(key: key);
  final Function onTimeSelected;
  final TimeOfDay initialTime;
  final RxString selectedTimeStr = 'Time'.obs;

  @override
  Widget build(BuildContext context) {
    selectedTimeStr.value =
        initialTime != null ? initialTime.format(context) : 'Time';
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(4.0),
        onTap: () async {
          var result = await showTimePicker(
              context: context, initialTime: initialTime ?? TimeOfDay.now());
          if (result != null) {
            selectedTimeStr.value = result.format(context);
            onTimeSelected?.call(selectedTimeStr.value);
          }
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
                "images/icons/ic_time.svg",
                height: 20,
                width: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
