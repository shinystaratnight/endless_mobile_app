import 'package:flutter/material.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/validator.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                width: 5,
              ),
              Text(
                hint,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: greyColor),
              ),
              SizedBox(
                width: 5,
              ),
              if (required)
                Text(
                  '✱',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: warningColor),
                ),
            ],
          ),
          SizedBox(
            height: 10,
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
            style: TextStyle(color: activeTextColor, fontSize: 16),
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: hintColor, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusColor: primaryColor,
                fillColor: whiteColor,
                filled: true,
                isDense: true,
                hintText: hint,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                hintStyle: TextStyle(color: hintColor, fontSize: 16),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ),
        ],
      ),
    );
  }
}