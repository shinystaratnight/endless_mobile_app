import 'package:flutter/material.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/validator.dart';

import '../../widgets/size_config.dart';

class CustomTextFieldWIthLabel extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final Function validator;
  final VoidCallback onTap;
  final bool required;
  final bool capital;
  final TextInputType type;
  const CustomTextFieldWIthLabel({
    Key key,
    this.type,
    this.hint,
    this.onChanged,
    this.controller,
    this.validator,
    this.onTap,
    this.required = true,
    this.capital,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints =
        BoxConstraints(maxWidth: size.width, maxHeight: size.height);
    SizeConfig().init(constraints, orientation);

    return Padding(
      padding: EdgeInsets.symmetric(
        //vertical: 10,
        vertical: SizeConfig.heightMultiplier * 1.46,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: primaryColor,
                radius: 2.5,
              ),
              SizedBox(
                //width: 5,
                width: SizeConfig.widthMultiplier * 1.22,
              ),
              Text(
                hint,
                style: TextStyle(
                  //fontSize: 12,
                  fontSize: SizeConfig.heightMultiplier * 1.76,
                  fontWeight: FontWeight.w400,
                  color: greyColor,
                ),
              ),
              SizedBox(
                //width: 5,
                width: SizeConfig.widthMultiplier * 1.22,
              ),
              if (required)
                Text(
                  '✱',
                  style: TextStyle(
                    //fontSize: 10,
                    fontSize: SizeConfig.heightMultiplier * 1.46,
                    fontWeight: FontWeight.w400,
                    color: warningColor,
                  ),
                ),
            ],
          ),
          SizedBox(
            //height: 10,
            height: SizeConfig.heightMultiplier * 1.46,
          ),
          TextFormField(
            textCapitalization: capital != null
                ? TextCapitalization.characters
                : TextCapitalization.none,
            keyboardType: type ?? TextInputType.text,
            onTap: onTap,
            readOnly: onTap != null,
            validator: required ? requiredValidator : null,
            controller: controller,
            onChanged: onChanged,
            style: TextStyle(
              color: activeTextColor,
              //fontSize: 16,
              fontSize: SizeConfig.heightMultiplier * 2.34,
            ),
            decoration: InputDecoration(
              errorStyle: TextStyle(
                color: Colors.red,
                //fontSize: 16,
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: hintColor, width: 1.0),
                borderRadius: BorderRadius.circular(
                  //8,
                  SizeConfig.heightMultiplier * 1.17,
                ),
              ),
              focusColor: primaryColor,
              fillColor: whiteColor,
              filled: true,
              isDense: true,
              hintText: hint,
              contentPadding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 4.86,
                vertical: SizeConfig.heightMultiplier * 2.34,
                // horizontal: 20,
                // vertical: 16,
              ),
              hintStyle: TextStyle(
                color: hintColor,
                //fontSize: 16,
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  //8,
                  SizeConfig.heightMultiplier * 1.17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
