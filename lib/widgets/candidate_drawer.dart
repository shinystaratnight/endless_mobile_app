import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:provider/provider.dart';

String img;

class CandidateDrawer extends StatefulWidget {
  final bool dashboard;

  CandidateDrawer({this.dashboard = false});

  @override
  State<CandidateDrawer> createState() => _CandidateDrawerState();
}

class _CandidateDrawerState extends State<CandidateDrawer> {
  final TextStyle _textStyle = TextStyle(fontSize: 17, color: Colors.blue);

  @override
  void initState() {
    if (img == null)
      Provider.of<ContactService>(context, listen: false)
          .getContactPicture(
              Provider.of<LoginService>(context, listen: false).user.userId)
          .then((value) {
        img = value;
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginService loginService = Provider.of<LoginService>(context);
    ContactService contactService = Provider.of<ContactService>(context);

    return Container(
      width: 250,
      decoration: BoxDecoration(color: Colors.white),
      child: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                        image: img != null
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(img),
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      loginService.user.name,
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
                ),
              ),
            ),
            !widget.dashboard
                ? ListTile(
                    title: Text(translate('page.title.dashboard'),
                        style: _textStyle),
                    onTap: () =>
                        Navigator.pushNamed(context, '/candidate_home'),
                  )
                : SizedBox(),
            !widget.dashboard
                ? Divider(
                    color: Colors.grey[300],
                  )
                : SizedBox(),
            ListTile(
              title: Text(translate('page.title.profile'), style: _textStyle),
              onTap: () => Navigator.pushNamed(context, '/candidate_profile'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title:
                  Text(translate('page.title.job_offers'), style: _textStyle),
              onTap: () =>
                  Navigator.pushNamed(context, '/candidate_job_offers'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text(translate('page.title.jobs'), style: _textStyle),
              onTap: () => Navigator.pushNamed(context, '/candidate_jobs'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title:
                  Text(translate('page.title.timesheets'), style: _textStyle),
              onTap: () =>
                  Navigator.pushNamed(context, '/candidate_timesheets'),
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
