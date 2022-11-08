import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/helpers/colors.dart';

class DatePickerBoxWidget extends StatefulWidget {
  DatePickerBoxWidget(
      {Key key,
      this.onDateSelected,
      this.initialDate,
      this.horPad,
      this.verPad,
      this.fontSize,
      this.imageHeight,
      this.imageWidth})
      : super(key: key);
  final Function onDateSelected;
  final DateTime initialDate;
  double horPad;
  double verPad;
  double fontSize;
  double imageHeight;
  double imageWidth;

  @override
  State<DatePickerBoxWidget> createState() => _DatePickerBoxWidgetState();
}

class _DatePickerBoxWidgetState extends State<DatePickerBoxWidget> {
  final RxString dateStr = 'Date'.obs;

  @override
  Widget build(BuildContext context1) {
    dateStr.value = widget.initialDate != null
        ? DateFormat('MMM dd, yyyy').format(widget.initialDate)
        : 'Date';
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(4.0),
        onTap: () async {
          var result = await showDatePicker(
            context: context1,
            initialDate: widget.initialDate ?? DateTime.now(),
            firstDate: DateTime(DateTime.now().year, DateTime.now().month - 2),
            lastDate: DateTime(DateTime.now().year, DateTime.now().month + 2),
          );
          if (result != null) {
            dateStr.value = DateFormat('MMM dd, yyyy').format(result);
            widget.onDateSelected?.call(result);
          }
        },
        child: Ink(
          padding: EdgeInsets.symmetric(
              horizontal: widget.horPad ?? 16, vertical: widget.verPad ?? 18),
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
                  dateStr.value,
                  style: TextStyle(
                      fontSize: widget.fontSize ?? 16, color: AppColors.lightBlack),
                ),
              ),
              SvgPicture.asset(
                "images/icons/ic_date.svg",
                height: widget.imageHeight ?? 20,
                width: widget.imageWidth ?? 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
