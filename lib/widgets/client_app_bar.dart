
import 'package:flutter/material.dart';
import 'package:piiprent/widgets/language-select.dart';
import 'package:piiprent/widgets/size_config.dart';

import '../screens/widgets/menu.dart';

Widget getClientAppBar(
  String title,
  BuildContext context, {
  List<Tab> tabs,
  Widget leading,
}) {
  return AppBar(
    actions: [
      SwitchAccount(),
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
