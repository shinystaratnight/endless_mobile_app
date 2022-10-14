import 'package:flutter/material.dart';
import 'package:piiprent/constants.dart';

class PrimaryOutlineButton extends StatelessWidget {
  final bool loading;
  final String btnText;
  final VoidCallback onPressed;
  const PrimaryOutlineButton({
    Key key,
    this.btnText,
    this.onPressed,
    this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width/2-20,
      height: 43,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: primaryColor, width: 2)),
        child: MaterialButton(
          elevation: 0.0,
          focusElevation: 0.0,
          disabledElevation: 0.0,
          splashColor: primaryColor,
          height: 43,
          minWidth: 164,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: whiteColor,
          onPressed: onPressed,
          child: loading ?? false
              ? CircularProgressIndicator(
                  color: primaryColor,
                )
              : Center(
                  child: Text(
                    btnText,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
