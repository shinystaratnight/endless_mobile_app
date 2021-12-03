import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piiprent/helpers/colors.dart';

class GeneralInformationWidget extends StatelessWidget {
  final String imageIcon;
  final String name;
  final String value;

  const GeneralInformationWidget(
      {this.imageIcon, this.name, this.value, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SvgPicture.asset(
            imageIcon,
            width: 14,
            height: 14,
          ),
          SizedBox(
            width: 6,
          ),
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.lightBlack,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
