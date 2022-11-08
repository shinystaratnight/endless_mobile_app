import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/login_provider.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';

import 'candidate_drawer.dart';

class ClientDrawer extends StatefulWidget {
  final bool dashboard;

  ClientDrawer({this.dashboard = false});

  @override
  State<ClientDrawer> createState() => _ClientDrawerState();
}

class _ClientDrawerState extends State<ClientDrawer> {
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
        print('client image: ==== $value');
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
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    SizeConfig().init(
        BoxConstraints(maxWidth: size.width, maxHeight: size.height),
        orientation);

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
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: Consumer<LoginProvider>(
                      builder: (_, login, __) {
                        return Column(
                          children: [
                            Container(
                              // height: SizeConfig.heightMultiplier * 12.04,
                              // width: SizeConfig.widthMultiplier * 27.63,
                              height: 100,
                              width: 100,
                              child: login.image == null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                // borderRadius: BorderRadius.circular(
                                //     SizeConfig.heightMultiplier * 20.78),
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    //size: 30,
                                    size: SizeConfig.heightMultiplier *
                                        4.78,
                                  ),
                                ),
                              )
                                  : ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                // borderRadius: BorderRadius.circular(
                                //     SizeConfig.heightMultiplier * 20.78),
                                child: CachedNetworkImage(
                                  imageUrl: login.image,
                                  fit: BoxFit.fill,
                                  progressIndicatorBuilder:
                                      (context, val, progress) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: progress.progress,
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) =>
                                      ImageContainer(
                                        content: Container(
                                            color: Colors.grey[400],
                                            child: new Icon(Icons.error)),
                                      ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.heightMultiplier * 1.46,
                              //height: 10,
                            ),
                            Text(
                              loginService.user != null
                                  ? loginService.user.name
                                  : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                //fontSize: 14,
                                fontSize: SizeConfig.heightMultiplier * 2.05,
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
            !widget.dashboard
                ? ListTile(
                    title: Text(translate('page.title.dashboard'),
                        style: _textStyle.copyWith(
                            fontSize: SizeConfig.textMultiplier * 2.64)),
                    onTap: () => Navigator.pushNamed(context, '/client_home'),
                  )
                : SizedBox(),
            !widget.dashboard
                ? Divider(
                    color: Colors.grey[300],
                  )
                : SizedBox(),
            ListTile(
              title: Text(translate('page.title.profile'),
                  style: _textStyle.copyWith(
                      fontSize: SizeConfig.textMultiplier * 2.64)),
              onTap: () => Navigator.pushNamed(context, '/client_profile'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text(translate('page.title.jobsites'),
                  style: _textStyle.copyWith(
                      fontSize: SizeConfig.textMultiplier * 2.64)),
              onTap: () => Navigator.pushNamed(context, '/client_jobsites'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text(translate('page.title.jobs'),
                  style: _textStyle.copyWith(
                      fontSize: SizeConfig.textMultiplier * 2.64)),
              onTap: () => Navigator.pushNamed(context, '/client_jobs'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text(translate('page.title.timesheets'),
                  style: _textStyle.copyWith(
                      fontSize: SizeConfig.textMultiplier * 2.64)),
              onTap: () => Navigator.pushNamed(context, '/client_timesheets'),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text(translate('button.logout'),
                  style: _textStyle.copyWith(
                      fontSize: SizeConfig.textMultiplier * 2.64)),
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
