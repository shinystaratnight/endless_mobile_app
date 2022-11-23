import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/widgets/size_config.dart';

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
      padding: EdgeInsets.only(
        //bottom: 17,
        bottom:SizeConfig.heightMultiplier*2.36,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (imageIcon != null)
            SvgPicture.asset(
              imageIcon,
              // width: 10,
              // height: 12,
              width: SizeConfig.widthMultiplier * 2.43,
              height: SizeConfig.heightMultiplier * 1.76,
            ),
          if (imageIcon != null)
            SizedBox(
              //width: 6,
              width: SizeConfig.widthMultiplier * 1.46,
            ),
          Text(
            name + ": ",
            style: TextStyle(
              fontFamily: GoogleFonts.roboto().fontFamily,
              color: AppColors.grey,
              fontWeight: FontWeight.w400,
              //fontSize: 12,
              fontSize: SizeConfig.heightMultiplier * 1.76,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.lightBlack,
              //fontSize: 14,
              fontSize: SizeConfig.heightMultiplier * 2.05,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
