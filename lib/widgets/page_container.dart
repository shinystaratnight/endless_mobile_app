import 'package:flutter/material.dart';

class PageContainer extends StatelessWidget {
  final Widget child;

  PageContainer({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: this.child,
    );
  }
}
