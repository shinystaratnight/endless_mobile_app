
import 'package:flutter/material.dart';
import 'package:piiprent/screens/candidate_notification_screen.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/language-select.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';

import '../screens/widgets/menu.dart';

Widget getCandidateAppBar(
  String title,
  BuildContext context, {
  bool showNotification = true,
  List<Tab> tabs,
  Widget leading,
}) {
  return AppBar(

    actions: [
      Consumer<LoginService>(
        builder: (_,loginService,__) {
          return Visibility(visible: loginService.user.roles!=null,child: SwitchAccount());
        }
      ),
      LanguageSelect(
      ),
      showNotification
          ? Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  iconSize: 24,
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CandidateNotificationScreen())),
                  icon: Icon(Icons.announcement),
                ),

                // TODO: implement showing functionality
                // Positioned(
                //   top: 14.0,
                //   right: 10.0,
                //   child: Container(
                //     alignment: Alignment.topRight,
                //     height: 10.0,
                //     width: 10.0,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: Colors.red[300],
                //       border: Border.all(
                //         color: Colors.white,
                //         width: 2.0,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            )
          : SizedBox(),
    ],
    title: Text(title,style: TextStyle(
      fontSize: SizeConfig.heightMultiplier*2.34
    ),),
    bottom: tabs != null ? TabBar(tabs: tabs) : null,
    leading: leading != null ? leading : null,
  );
}
