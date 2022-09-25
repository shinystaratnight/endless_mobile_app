import 'package:flutter/material.dart';
import 'package:piiprent/constants.dart';

class StepComponent extends StatelessWidget {
  final bool done;
  final bool active;
  final String label;
  final String number;
  const StepComponent({
    Key key,
    this.done,
    this.active,
    this.label,
    this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            child: done
                ? Icon(
                    Icons.check,
                    color: whiteColor,
                    size: 15,
                  )
                : active
                    ? Text(
                        number,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: whiteColor),
                      )
                    : Text(
                        number,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: greyColor.withOpacity(.5)),
                      ),
            radius: 15,
            backgroundColor: done
                ? successColor
                : active
                    ? primaryColor
                    : lightBlue,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 1.1,
                color: done
                    ? successColor
                    : active
                        ? primaryColor
                        : greyColor.withOpacity(.5)),
          )
        ],
      ),
    );
  }
}
