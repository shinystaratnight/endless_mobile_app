import 'package:flutter/material.dart';
import 'package:piiprent/screens/candidate_notification_screen.dart';

Widget getCandidateAppBar(String title, BuildContext context,
    {bool showNotification = true, List<Tab> tabs}) {
  return AppBar(actions: [
    showNotification
        ? Stack(alignment: Alignment.center, children: [
            IconButton(
              iconSize: 24,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CandidateNotificationScreen())),
              icon: Icon(Icons.announcement),
            ),
            Positioned(
              top: 14.0,
              right: 10.0,
              child: Container(
                alignment: Alignment.topRight,
                height: 10.0,
                width: 10.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red[300],
                ),
              ),
            ),
          ])
        : SizedBox(),
  ], title: Text(title), bottom: tabs != null ? TabBar(tabs: tabs) : null);
}
