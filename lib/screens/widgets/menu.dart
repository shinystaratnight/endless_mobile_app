// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_portal/flutter_portal.dart';
// import 'package:piiprent/models/role_model.dart';
// import 'package:piiprent/screens/widgets/primary_button.dart';
// import 'package:piiprent/services/login_service.dart';
// import 'package:provider/provider.dart';
// import '../../constants.dart';
// import '../../login_provider.dart';
// import '../../services/contact_service.dart';
// import '../../widgets/size_config.dart';
//
// bool showSwitchAccountMenu = false;
//
// class SwitchAccount extends StatefulWidget {
//   const SwitchAccount({Key key}) : super(key: key);
//
//   @override
//   SwitchAccountState createState() => SwitchAccountState();
// }
//
//
//
// class SwitchAccountState extends State<SwitchAccount> {
//   LoginService loginService;
//
//

//   @override
//   initState() {
//     loginService = Provider.of<LoginService>(context, listen: false);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 8.0),
//       child: Consumer<CloseSwitchMenu>(builder: (_, con, __) {
//         return _ModalEntry(
//           onClose: () => setState(() => con.closeMenu = (false)),
//           childAnchor: Alignment.topRight,
//           menuAnchor: Alignment.topLeft,
//           menu: Card(
//             //elevation: 12,
//             elevation: SizeConfig.heightMultiplier * 1.76,
//             child: Container(
//               height: loginService.user.roles != null
//                   ? (loginService.user.roles.length * 100).toDouble()
//                   : 170,
//               width: SizeConfig.widthMultiplier * 36.50,
//               constraints: BoxConstraints(
//                 maxHeight: 900,
//                 minHeight: 150,
//               ),
//               // height: 290,
//               // width: 150,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Menu(
//                         children: [
//                           ...List.generate(
//                             loginService.user.roles != null
//                                 ? loginService.user.roles.length
//                                 : 0,
//                             (index) {
//                               Role role = loginService.user.roles[index];
//                               return Container(
//                                 color: (role.active == null ||
//                                         role.active == false)
//                                     ? Colors.white
//                                     : Colors.blueAccent.withOpacity(0.2),
//                                 child: ListTile(
//                                   onTap: () async {
//                                     setState(
//                                         () =>con.closeMenu = false);
//                                     if (Provider.of<LoginProvider>(context,
//                                                 listen: false)
//                                             .switchRole !=
//                                         index) {
//                                       for (int i = 0;
//                                           i < loginService.user.roles.length;
//                                           i++) {
//                                         if (i != index) {
//                                           loginService.user.roles[i].active =
//                                               false;
//                                         } else {
//                                           loginService.user.roles[i].active =
//                                               true;
//                                         }
//                                       }
//                                       Provider.of<LoginProvider>(context,
//                                               listen: false)
//                                           .switchRole = index;
//                                       Navigator.pushNamedAndRemoveUntil(
//                                           context, '/', (route) => false);
//                                     }
//                                   },
//                                   //minLeadingWidth: 60,
//                                   minLeadingWidth:
//                                       SizeConfig.widthMultiplier * 14.60,
//                                   leading: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       (role.active == null ||
//                                               role.active == false)
//                                           ? Icon(
//                                               Icons.radio_button_off,
//                                             )
//                                           : Icon(
//                                               Icons.radio_button_checked,
//                                               color: Colors.indigo,
//                                             ),
//                                       SizedBox(
//                                         //width: 8,
//                                         width:
//                                             SizeConfig.widthMultiplier * 1.95,
//                                       ),
//                                       AccountImage(),
//                                     ],
//                                   ),
//                                   title: Text(
//                                     loginService.user.name,
//                                     textAlign: TextAlign.start,
//                                     overflow: TextOverflow.ellipsis,
//                                     maxLines: 1,
//                                     style: TextStyle(
//                                         //fontSize: 16,
//                                         fontSize:
//                                             SizeConfig.heightMultiplier * 2.34,
//                                         color: Colors.indigo,
//                                         fontWeight: FontWeight.w700),
//                                   ),
//                                   subtitle: Padding(
//                                     padding: EdgeInsets.only(
//                                       //top: 5.0,
//                                       top: SizeConfig.heightMultiplier * 0.61,
//                                     ),
//                                     child: Text(
//                                       '${role.name}',
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         //fontSize: 14,
//                                         fontSize:
//                                             SizeConfig.heightMultiplier * 2.05,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     //height: 4,
//                     height: SizeConfig.heightMultiplier * 0.59,
//                   ),
//                   Divider(),
//                   SizedBox(
//                     //height: 4,
//                     height: SizeConfig.heightMultiplier * 0.59,
//                   ),
//                   Align(
//                     alignment: Alignment.center,
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                           right: SizeConfig.widthMultiplier * 14.60),
//                       child: PrimaryButton(
//                         btnText: 'Logout',
//                         buttonColor: Colors.indigo,
//                         onPressed: () {
//                           loginService.logout(context: context).then(
//                                 (bool success) =>
//                                     Navigator.pushNamed(context, '/'),
//                               );
//                         },
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     //height: 10,
//                     height: SizeConfig.heightMultiplier * 1.46,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           child: InkWell(
//             onTap: () => setState(() => con.closeMenu = (true)),
//             child: AccountImage(),
//           ),
//         );
//       }),
//     );
//   }
// }
//
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piiprent/screens/widgets/primary_button.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../login_provider.dart';
import '../../models/role_model.dart';
import '../../services/contact_service.dart';
import '../../services/login_service.dart';
import '../../widgets/size_config.dart';

// class CloseSwitchMenu extends ChangeNotifier {
//   bool _closeMenu = false;
//   get closeMenu => _closeMenu;
//   set closeMenu(val) {
//     _closeMenu = val;
//     notifyListeners();
//   }
// }
//
// class Menu extends StatelessWidget {
//   const Menu({
//     Key key,
//     @required this.children,
//   }) : super(key: key);
//
//   final List<Widget> children;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: children,
//     );
//   }
// }
//
// class _ModalEntry extends StatelessWidget {
//   const _ModalEntry({
//     Key key,
//     @required this.onClose,
//     @required this.menu,
//     @required this.visible,
//     @required this.menuAnchor,
//     @required this.childAnchor,
//     @required this.child,
//   }) : super(key: key);
//
//   final VoidCallback onClose;
//   final Widget menu;
//   final bool visible;
//   final Widget child;
//   final Alignment menuAnchor;
//   final Alignment childAnchor;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: visible ? onClose : null,
//       child: Consumer<CloseSwitchMenu>(builder: (_, con, __) {
//         return PortalTarget(
//           visible: con.closeMenu,
//           portalFollower: menu,
//           anchor: const Aligned(
//             follower: Alignment.topLeft,
//             target: Alignment.bottomLeft,
//             //widthFactor: 12.8,
//             widthFactor: 12.8,
//             backup: Aligned(
//               follower: Alignment.topCenter,
//               target: Alignment.bottomLeft,
//             ),
//           ),
//           child: IgnorePointer(
//             ignoring: con.closeMenu,
//             child: child,
//           ),
//         );
//       }),
//     );
//   }
// }
//
// class AccountImage extends StatefulWidget {
//   const AccountImage({Key key}) : super(key: key);
//
//   @override
//   State<AccountImage> createState() => _AccountImageState();
// }
//
// class _AccountImageState extends State<AccountImage> {
//   LoginService loginService;
//   @override
//   initState() {
//     loginService = Provider.of<LoginService>(context, listen: false);
//     debugPrint('roles: ============= ${loginService.user.roles}');
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ContactService contactService = Provider.of<ContactService>(context);
//     return FutureBuilder(
//       future: contactService.getContactPicture(loginService.user.userId),
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         return Container(
//           //margin: EdgeInsets.symmetric(vertical: 15),
//           margin: EdgeInsets.symmetric(
//             vertical: SizeConfig.heightMultiplier * 2.34,
//           ),
//           child: Consumer<LoginProvider>(
//             builder: (_, login, __) {
//               return Container(
//                 height: SizeConfig.heightMultiplier * 6.86,
//                 width: SizeConfig.widthMultiplier * 9.73,
//                 // height: 40,
//                 // width: 40,
//                 clipBehavior: Clip.antiAlias,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                 ),
//                 child: login.image == null || login.image == ''
//                     ? Icon(
//                         CupertinoIcons.person_fill,
//                         // size: 90,
//                         size: SizeConfig.heightMultiplier * 4.06,
//                         color: primaryColor,
//                       )
//                     : ClipRRect(
//                         borderRadius: BorderRadius.circular(60),
//                         // borderRadius: BorderRadius.circular(
//                         //   SizeConfig.heightMultiplier *
//                         //       34.5 /
//                         //       SizeConfig.widthMultiplier *
//                         //       40.345,
//                         // ),
//                         child: CachedNetworkImage(
//                           imageUrl: login.image,
//                           fit: BoxFit.fill,
//                           cacheManager: login.cacheManager,
//                           progressIndicatorBuilder: (context, val, progress) {
//                             return Loading();
//                           },
//                           errorWidget: (context, url, error) =>
//                               Error(),
//                         ),
//                       ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
//
//
//
// class Loading extends StatelessWidget {
//   const Loading({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Container(
//       height: SizeConfig.heightMultiplier * 6.86,
//       width: SizeConfig.widthMultiplier * 9.73,
//       // height: 40,
//       // width: 40,
//       clipBehavior: Clip.antiAlias,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.white,
//       ),
//       child: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
//
// class Error extends StatelessWidget {
//   const Error({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//       height: SizeConfig.heightMultiplier * 6.86,
//       width: SizeConfig.widthMultiplier * 9.73,
//       // height: 40,
//       // width: 40,
//       clipBehavior: Clip.antiAlias,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.white,
//       ),
//       child: Center(
//         child: Icon(
//           Icons.error,
//           color: Colors.red,
//           //size: 90,
//           size: SizeConfig.heightMultiplier * 13.17,
//         ),
//       ),
//     );
//   }
// }
//

class SwitchAccount extends StatefulWidget {
  const SwitchAccount({Key key}) : super(key: key);

  @override
  State<SwitchAccount> createState() => _SwitchAccountState();
}

class _SwitchAccountState extends State<SwitchAccount> {
  //

  LoginService loginService;

  @override
  initState() {
    loginService = Provider.of<LoginService>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: Offset(MediaQuery.of(context).size.width, 0),
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      itemBuilder: (context) {
        return List.generate(
          loginService.user.roles != null
              ? loginService.user.roles.length + 1
              : 0,
          (index) {
            Role role;
            if (index != loginService.user.roles.length) {
              role = loginService.user.roles[index];
            }

            return index == loginService.user.roles.length
                ? PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                  )
                : PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: Container(
                      width: Get.width,
                      // decoration:
                      //     BoxDecoration(border: Border.all(color: Colors.red)),
                      color: (role.active == null || role.active == false)
                          ? Colors.white
                          : Colors.blueAccent.withOpacity(0.2),
                      child: Column(
                        children: [
                          ListTile(
                            minLeadingWidth: SizeConfig.widthMultiplier * 14.60,
                            onTap: () async {
                              if (Provider.of<LoginProvider>(context, listen: false)
                                      .switchRole !=
                                  index) {
                                for (int i = 0;
                                    i < loginService.user.roles.length;
                                    i++) {
                                  if (i != index) {
                                    loginService.user.roles[i].active = false;
                                  } else {
                                    loginService.user.roles[i].active = true;
                                  }
                                }
                                Provider.of<LoginProvider>(context, listen: false)
                                    .switchRole = index;
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/', (route) => false);
                              }
                            },
                            //minLeadingWidth: 60,
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                (role.active == null || role.active == false)
                                    ? Icon(
                                        Icons.radio_button_off,
                                      )
                                    : Icon(
                                        Icons.radio_button_checked,
                                        color: Colors.indigo,
                                      ),
                                SizedBox(
                                  // width: 4,
                                  width: SizeConfig.widthMultiplier * 1.95,
                                ),
                                AccountImage(),
                              ],
                            ),
                            title: Container(
                              // decoration: BoxDecoration(border: Border.all()),
                              // width: 50,
                              child: Text(
                                loginService.user.name,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.visible,
                                // maxLines: 2,
                                style: TextStyle(
                                    //fontSize: 16,
                                    fontSize: SizeConfig.heightMultiplier * 2.34,
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w700),
                              ),
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
                                  fontSize: SizeConfig.heightMultiplier * 2.05,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),

                         /* InkWell(
                            onTap: (){
                              if (Provider.of<LoginProvider>(context, listen: false)
                                  .switchRole !=
                                  index) {
                                for (int i = 0;
                                i < loginService.user.roles.length;
                                i++) {
                                  if (i != index) {
                                    loginService.user.roles[i].active = false;
                                  } else {
                                    loginService.user.roles[i].active = true;
                                  }
                                }
                                Provider.of<LoginProvider>(context, listen: false)
                                    .switchRole = index;
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/', (route) => false);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                (role.active == null || role.active == false)
                                    ? Icon(
                                  Icons.radio_button_off,
                                )
                                    : Icon(
                                  Icons.radio_button_checked,
                                  color: Colors.indigo,
                                ),
                                SizedBox(
                                  // width: 4,
                                  width: SizeConfig.widthMultiplier * 1.95,
                                ),
                                AccountImage(),
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(border: Border.all()),
                                      width: 50,
                                      child: Text(
                                        loginService.user.name,
                                        textAlign: TextAlign.start,
                                        // overflow: TextOverflow.visible,
                                        maxLines: 1,
                                        style: TextStyle(
                                          //fontSize: 16,
                                          //   fontSize: SizeConfig.heightMultiplier * 2.34,
                                            color: Colors.indigo,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Padding(
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
                                          fontSize: SizeConfig.heightMultiplier * 2.05,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],

                            ),
                          )*/
                        ],
                      ),
                    ),
                  );
          },
        );
      },
      child: InkWell(
        child: AccountImage(),
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
                            return Loading();
                          },
                          errorWidget: (context, url, error) => Error(),
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

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class Error extends StatelessWidget {
  const Error({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: Center(
        child: Icon(
          Icons.error,
          color: Colors.red,
          //size: 90,
          size: SizeConfig.heightMultiplier * 13.17,
        ),
      ),
    );
  }
}
