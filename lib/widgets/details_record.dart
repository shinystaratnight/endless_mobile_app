import 'package:flutter/material.dart';
import 'package:piiprent/widgets/size_config.dart';

class DetailsRecord extends StatelessWidget {
  final String label;
  final String value;
  final Widget button;

  DetailsRecord({this.label, this.value = '', this.button});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        // horizontal: 8.0,
        // vertical: 12.0,
        horizontal: SizeConfig.widthMultiplier * 1.94,
        vertical: SizeConfig.heightMultiplier * 1.76,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  label + ":",
                  style:
                      TextStyle(fontSize: SizeConfig.heightMultiplier * 2.34),
                ),
                SizedBox(
                  //width: 8.0,
                  width: SizeConfig.widthMultiplier * 1.94,
                ),
                Expanded(
                  child: Row(
                    children: this.button != null
                        ? [
                            Text(
                              value != null ? value : '',
                              style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier * 2.34,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(child: this.button)
                          ]
                        : [
                            Expanded(
                              child: Text(
                                value != null ? value : '',
                                style: TextStyle(
                                  fontSize: SizeConfig.heightMultiplier * 2.34,
                                ),
                              ),
                            ),
                          ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
