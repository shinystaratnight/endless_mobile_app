import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/login_provider.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:provider/provider.dart';

//String img;

class CandidateDrawer extends StatefulWidget {
  final bool dashboard;

  CandidateDrawer({this.dashboard = false});

  @override
  State<CandidateDrawer> createState() => _CandidateDrawerState();
}

class _CandidateDrawerState extends State<CandidateDrawer> {
  final TextStyle _textStyle = TextStyle(fontSize: 17, color: Colors.blue);
  LoginService _loginService;
  bool _isLoading = true;
  @override
  void initState() {
    _loginService = Provider.of<LoginService>(context, listen: false);

    if (Provider.of<LoginProvider>(context, listen: false).image == null)
      Provider.of<ContactService>(context, listen: false)
          .getContactPicture(_loginService.user.userId)
          .then((value) {
        Provider.of<LoginProvider>(context, listen: false).image = value;
        setState(() {});
      });
    setState(() {
      _isLoading = false;
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
                    Consumer<LoginProvider>(
                      builder: (_, login, __) {
                        return Container(
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
                        );
                      },
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

class ImageContainer extends StatelessWidget {
  const ImageContainer({Key key, this.content}) : super(key: key);
  final Widget content;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.2),
      ),
      child: content,
    );
  }
}

// SizedBox(width: 100,
// height: 100,
// child: ClipRRect(
// borderRadius: BorderRadius.circular(70),
// child: Image.network(
// login.image,
// fit: BoxFit.fill,
// loadingBuilder: (BuildContext context, Widget child,
// ImageChunkEvent loadingProgress) {
// if (loadingProgress == null) return child;
// return Center(
// child: CircularProgressIndicator(
// value: loadingProgress.expectedTotalBytes != null
// ? loadingProgress.cumulativeBytesLoaded /
// loadingProgress.expectedTotalBytes
//     : null,
// ),
// );
// },
// ),
// ),
// )
