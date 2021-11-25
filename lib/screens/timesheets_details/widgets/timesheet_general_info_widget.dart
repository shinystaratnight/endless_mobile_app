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
      padding: EdgeInsets.only(bottom: 5, top: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              alignment: Alignment.topLeft,
              width: 30,
              child: SvgPicture.asset(imageIcon)),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Expanded(flex: 4, child: Container(child: Text(value))),
        ],
      ),
    );
  }
}
