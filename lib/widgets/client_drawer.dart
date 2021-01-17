import 'package:flutter/material.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:provider/provider.dart';

class ClientDrawer extends StatelessWidget {
  final TextStyle _textStyle = TextStyle(fontSize: 18, color: Colors.blue);
  final bool dashboard;

  ClientDrawer({this.dashboard = false});

  @override
  Widget build(BuildContext context) {
    LoginService loginService = Provider.of<LoginService>(context);
    ContactService contactService = Provider.of<ContactService>(context);

    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            FutureBuilder(
              future: contactService.getContactPicture(loginService.user.userId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return DrawerHeader(
                  child: Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                        image: snapshot.hasData
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    NetworkImage(snapshot.data),
                              )
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
            !dashboard
                ? ListTile(
                    title: Text('Dashboard', style: _textStyle),
                    onTap: () => Navigator.pushNamed(context, '/client_home'),
                  )
                : SizedBox(),
            !dashboard
                ? Divider(
                    color: Colors.grey[300],
                  )
                : SizedBox(),
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
              onTap: () => {
                loginService
                    .logout()
                    .then((bool success) => Navigator.pushNamed(context, '/'))
              },
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
