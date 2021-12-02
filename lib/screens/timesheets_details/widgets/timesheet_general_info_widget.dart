import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
            width: 12.24,
            height: 12.25,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: TextStyle(color: Color(0xFF7A7A7A), fontSize: 12),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              child: Text(
                value,
                style: TextStyle(
                  color: Color(0xff2F363D),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
