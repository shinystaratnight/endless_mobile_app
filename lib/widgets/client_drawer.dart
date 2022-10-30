import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/login_provider.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:provider/provider.dart';

import 'candidate_drawer.dart';

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
              future:
                  contactService.getContactPicture(loginService.user.userId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return DrawerHeader(
                  child: Center(
                    child: Consumer<LoginProvider>(
                      builder: (_, login, __) {
                        return Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: CachedNetworkImage(
                                  imageUrl: login.image,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                        child: new CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      ImageContainer(
                                    content: Center(child: new Icon(Icons.error)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              loginService.user != null ? loginService.user.name : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            !dashboard
                ? ListTile(
                    title: Text(translate('page.title.dashboard'),
                        style: _textStyle),
                    onTap: () => Navigator.pushNamed(context, '/client_home'),
                  )
                : SizedBox(),
            !dashboard
                ? Divider(
                    color: Colors.grey[300],
                  )
                : SizedBox(),
            ListTile(
              title: Text(translate('page.title.profile'), style: _textStyle),
              onTap: () => Navigator.pushNamed(context, '/client_profile'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text(translate('page.title.jobsites'), style: _textStyle),
              onTap: () => Navigator.pushNamed(context, '/client_jobsites'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text(translate('page.title.jobs'), style: _textStyle),
              onTap: () => Navigator.pushNamed(context, '/client_jobs'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title:
                  Text(translate('page.title.timesheets'), style: _textStyle),
              onTap: () => Navigator.pushNamed(context, '/client_timesheets'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text(translate('button.logout'), style: _textStyle),
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
