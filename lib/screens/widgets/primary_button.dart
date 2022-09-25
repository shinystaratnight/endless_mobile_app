import 'package:flutter/material.dart';
import 'package:piiprent/constants.dart';

class PrimaryButton extends StatelessWidget {
  final bool loading;
  final String btnText;
  final VoidCallback onPressed;
  const PrimaryButton({
    Key key,
    this.btnText,
    this.onPressed,
    this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      width: 164,
      child: MaterialButton(
        splashColor: whiteColor,
        height: 43,
        minWidth: 164,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: primaryColor,
        disabledColor: primaryColor.withOpacity(.5),
        onPressed: onPressed,
        child: loading ?? false
            ? CircularProgressIndicator(
                color: whiteColor,
              )
            : Center(
                child: Text(
                  btnText,
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
      ),
    );
  }
}
