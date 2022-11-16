
import 'package:flutter/material.dart';
import 'package:piiprent/widgets/language-select.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';

import '../screens/widgets/menu.dart';
import '../services/login_service.dart';

Widget getClientAppBar(
  String title,
  BuildContext context, {
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
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: LanguageSelect(
        ),
      ),
    ],
    title: Text(title,style: TextStyle(fontSize: SizeConfig.heightMultiplier*2.34),),
    bottom: tabs != null ? TabBar(tabs: tabs) : null,
    leading: leading != null ? leading : null,
  );
}
