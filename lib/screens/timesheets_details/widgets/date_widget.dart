import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DateButtonWidget extends StatefulWidget {
  const DateButtonWidget({Key key}) : super(key: key);

  @override
  State<DateButtonWidget> createState() => _DateButtonWidgetState();
}

class _DateButtonWidgetState extends State<DateButtonWidget> {
  DateTime _date = new DateTime.now();

  Future selectDate(BuildContext context) async {
    DateTime _picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2016),
      lastDate: DateTime(2022),
    );
    if (_picked != null && _picked != _date) {
      setState(() {
        _date = _picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          FlatButton(
            child: Container(
              width: 155,
              height: 56,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xffEEF6FF),
                border: Border.all(
                  width: 1,
                  color: Color(0xffD3DEEA),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0), //         <--- border radius here
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date',
                    style: TextStyle(fontSize: 16),
                  ),
                  SvgPicture.asset("images/icons/ic_date.svg"),
                ],
              ),
            ),
            onPressed: () => selectDate(context),
          ),
        ],
      ),
    );
  }
}
