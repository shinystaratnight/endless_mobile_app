import 'package:flutter/material.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:provider/provider.dart';

class CandidateDrawer extends StatelessWidget {
  final TextStyle _textStyle = TextStyle(fontSize: 18, color: Colors.blue);
  final bool dashboard;

  CandidateDrawer({this.dashboard = false});

  @override
  Widget build(BuildContext context) {
    LoginService loginService = Provider.of<LoginService>(context);

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
                    image: loginService.user.picture != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                NetworkImage(loginService.user.userAvatarUrl()),
                          )
                        : null,
                  ),
                ),
              ),
            ),
            !dashboard
                ? ListTile(
                    title: Text('Dashboard', style: _textStyle),
                    onTap: () =>
                        Navigator.pushNamed(context, '/candidate_home'),
                  )
                : SizedBox(),
            !dashboard
                ? Divider(
                    color: Colors.grey[300],
                  )
                : SizedBox(),
            ListTile(
              title: Text('Profile', style: _textStyle),
              onTap: () => Navigator.pushNamed(context, '/candidate_profile'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text('Job Offers', style: _textStyle),
              onTap: () =>
                  Navigator.pushNamed(context, '/candidate_job_offers'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text('Jobs', style: _textStyle),
              onTap: () => Navigator.pushNamed(context, '/candidate_jobs'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text('Timesheets', style: _textStyle),
              onTap: () =>
                  Navigator.pushNamed(context, '/candidate_timesheets'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text('Logout', style: _textStyle),
              onTap: () => {
                if (loginService.logout()) {Navigator.pushNamed(context, '/')}
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
