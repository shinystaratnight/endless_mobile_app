import 'package:flutter/material.dart';

class HomeScreenButton extends StatefulWidget {
  final Icon icon;
  final String text;
  final Color color;
  final String path;

  HomeScreenButton({this.icon, this.text, this.color, this.path});

  @override
  _HomeScreenButtonState createState() => _HomeScreenButtonState();
}

class _HomeScreenButtonState extends State<HomeScreenButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.3),
                //     spreadRadius: 3,
                //     blurRadius: 5,
                //     offset: Offset(0, 2),
                //   ),
                // ],
              ),
              child: widget.icon,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(widget.text, style: TextStyle(color: Colors.white)),
          ],
        ),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
      onTap: () => Navigator.pushNamed(context, widget.path),
    );
  }
}
