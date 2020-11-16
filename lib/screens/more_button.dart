import 'package:flutter/material.dart';

class MoreButton extends StatelessWidget {
  final bool isShow;
  final Stream stream;
  final Function onPressed;

  MoreButton({this.isShow, this.stream, this.onPressed});

  _buildWrapper(child) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isShow) {
      return SizedBox();
    }

    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        bool fetching = snapshot.hasData && snapshot.data;

        if (fetching) {
          return _buildWrapper(CircularProgressIndicator());
        }

        return _buildWrapper(
          RaisedButton(
            onPressed: onPressed,
            child: Text('Upload'),
          ),
        );
      },
    );
  }
}
