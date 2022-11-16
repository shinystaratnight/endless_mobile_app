import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:piiprent/models/role_model.dart';
import 'package:piiprent/screens/widgets/primary_button.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../login_provider.dart';
import '../../services/contact_service.dart';
import '../../widgets/size_config.dart';
import '../auth/login_screen.dart';
import '../preview_screen.dart';
import 'network_image_widgets.dart';

class SwitchAccount extends StatefulWidget {
  const SwitchAccount({Key key}) : super(key: key);

  @override
  _SwitchAccountState createState() => _SwitchAccountState();
}

class _SwitchAccountState extends State<SwitchAccount> {
  bool _showMenu = false;
  LoginService loginService;
  @override
  initState() {
    loginService = Provider.of<LoginService>(context, listen: false);
    debugPrint('roles: ============= ${loginService.user.roles}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ContactService contactService = Provider.of<ContactService>(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: _ModalEntry(
        visible: _showMenu,
        onClose: () => setState(() => _showMenu = false),
        childAnchor: Alignment.topRight,
        menuAnchor: Alignment.topLeft,
        menu: Card(
          //elevation: 12,
          elevation: SizeConfig.heightMultiplier * 1.76,
          child: Container(
            height: loginService.user.roles != null
                ? (loginService.user.roles.length * 100).toDouble()
                : 150,
            width: SizeConfig.widthMultiplier * 36.50,
            constraints: BoxConstraints(
              maxHeight: 900,
              minHeight: 150,
            ),
            // height: 290,
            // width: 150,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Menu(
                      children: [
                        ...List.generate(
                          loginService.user.roles != null
                              ? loginService.user.roles.length
                              : 0,
                          (index) {
                            Role role = loginService.user.roles[index];
                            return Container(
                              color:
                                  (role.active == null || role.active == false)
                                      ? Colors.white
                                      : Colors.blueAccent.withOpacity(0.2),
                              child: ListTile(
                                onTap: () async {
                                  setState(() => _showMenu = false);
                                  if (Provider.of<LoginProvider>(context,
                                              listen: false)
                                          .switchRole !=
                                      index) {
                                    for (int i = 0;
                                        i < loginService.user.roles.length;
                                        i++) {
                                      if (i != index) {
                                        loginService.user.roles[i].active =
                                            false;
                                      } else {
                                        loginService.user.roles[i].active =
                                            true;
                                      }
                                    }
                                    //await deleteImageFromCache(Provider.of<LoginProvider>(context,listen: false).image);
                                    //PaintingBinding.instance.imageCache.clear();
                                    Provider.of<LoginProvider>(context,
                                            listen: false)
                                        .switchRole = index;
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/', (route) => false);
                                  }
                                },
                                //minLeadingWidth: 60,
                                minLeadingWidth:
                                    SizeConfig.widthMultiplier * 14.60,
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    (role.active == null ||
                                            role.active == false)
                                        ? Icon(
                                            Icons.radio_button_off,
                                          )
                                        : Icon(
                                            Icons.radio_button_checked,
                                            color: Colors.indigo,
                                          ),
                                    SizedBox(
                                      //width: 8,
                                      width: SizeConfig.widthMultiplier * 1.95,
                                    ),
                                    AccountImage(),
                                  ],
                                ),
                                title: Text(
                                  loginService.user.name,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      //fontSize: 16,
                                      fontSize:
                                          SizeConfig.heightMultiplier * 2.34,
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.w700),
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.only(
                                    //top: 5.0,
                                    top: SizeConfig.heightMultiplier * 0.61,
                                  ),
                                  child: Text(
                                    '${role.name}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      //fontSize: 14,
                                      fontSize:
                                          SizeConfig.heightMultiplier * 2.05,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          //height: 4,
                          height: SizeConfig.heightMultiplier * 0.59,
                        ),
                        Divider(),
                        SizedBox(
                          //height: 4,
                          height: SizeConfig.heightMultiplier * 0.59,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: SizeConfig.widthMultiplier * 14.60),
                            child: PrimaryButton(
                              btnText: 'Logout',
                              buttonColor: Colors.indigo,
                              onPressed: () {
                                loginService.logout(context: context).then(
                                      (bool success) =>
                                          Navigator.pushNamed(context, '/'),
                                    );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          //height: 10,
                          height: SizeConfig.heightMultiplier * 1.46,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: InkWell(
          onTap: () => setState(() => _showMenu = true),
          child: AccountImage(),
        ),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  const Menu({
    Key key,
    @required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class _ModalEntry extends StatelessWidget {
  const _ModalEntry({
    Key key,
    @required this.onClose,
    @required this.menu,
    @required this.visible,
    @required this.menuAnchor,
    @required this.childAnchor,
    @required this.child,
  }) : super(key: key);

  final VoidCallback onClose;
  final Widget menu;
  final bool visible;
  final Widget child;
  final Alignment menuAnchor;
  final Alignment childAnchor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: visible ? onClose : null,
      child: PortalTarget(
        visible: visible,
        portalFollower: menu,
        anchor: const Aligned(
          follower: Alignment.topLeft,
          target: Alignment.bottomLeft,
          //widthFactor: 12.8,
          widthFactor: 12.8,
          backup: Aligned(
            follower: Alignment.topCenter,
            target: Alignment.bottomLeft,
          ),
        ),
        child: IgnorePointer(
          ignoring: visible,
          child: child,
        ),
      ),
    );
  }
}

class AccountImage extends StatefulWidget {
  const AccountImage({Key key}) : super(key: key);

  @override
  State<AccountImage> createState() => _AccountImageState();
}

class _AccountImageState extends State<AccountImage> {
  LoginService loginService;
  @override
  initState() {
    loginService = Provider.of<LoginService>(context, listen: false);
    debugPrint('roles: ============= ${loginService.user.roles}');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ContactService contactService = Provider.of<ContactService>(context);
    return FutureBuilder(
      future: contactService.getContactPicture(loginService.user.userId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          //margin: EdgeInsets.symmetric(vertical: 15),
          margin: EdgeInsets.symmetric(
            vertical: SizeConfig.heightMultiplier * 2.34,
          ),
          child: Consumer<LoginProvider>(
            builder: (_, login, __) {
              return Container(
                height: SizeConfig.heightMultiplier * 6.86,
                width: SizeConfig.widthMultiplier * 9.73,
                // height: 40,
                // width: 40,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: login.image == null || login.image == ''
                    ? Icon(
                        CupertinoIcons.person_fill,
                        // size: 90,
                        size: SizeConfig.heightMultiplier * 4.06,
                        color: primaryColor,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        // borderRadius: BorderRadius.circular(
                        //   SizeConfig.heightMultiplier *
                        //       34.5 /
                        //       SizeConfig.widthMultiplier *
                        //       40.345,
                        // ),
                        child: CachedNetworkImage(
                          imageUrl: login.image,
                          fit: BoxFit.fill,
                          cacheManager: login.cacheManager,
                          progressIndicatorBuilder: (context, val, progress) {
                            return ImageLoadingContainer();
                          },
                          errorWidget: (context, url, error) =>
                              ImageErrorWidget(),
                        ),
                      ),
              );
            },
          ),
        );
      },
    );
  }
}
