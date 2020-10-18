import 'package:flutter/material.dart';

class ClientDrawer extends StatelessWidget {
  final TextStyle _textStyle = TextStyle(fontSize: 18, color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage('https://picsum.photos/200/300'),
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  // color: Colors.blue,
                  ),
            ),
            ListTile(
              title: Text('Dashboard', style: _textStyle),
              onTap: () => Navigator.pushNamed(context, '/client_home'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text('Profile', style: _textStyle),
              onTap: () => Navigator.pushNamed(context, '/client_profile'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text('Jobs', style: _textStyle),
              onTap: () => Navigator.pushNamed(context, '/client_jobs'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text('Timesheets', style: _textStyle),
              onTap: () => Navigator.pushNamed(context, '/client_timesheets'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text('Logout', style: _textStyle),
              onTap: () => Navigator.pushNamed(context, '/'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
