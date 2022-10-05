import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/mixins/change_language.dart';

class LanguageSelect extends StatelessWidget with ChangeLanguage {
  final CustomPopupMenuController controller;
  Color _color;

  LanguageSelect({
    color = Colors.white,
    @required this.controller,
  }) {
    _color = color;
  }

  List<String> lans = [
    translate('language.name.en'),
    translate('language.name.et'),
    translate('language.name.fi'),
    translate('language.name.ru'),
  ];
  List<String> codes = [
    'en',
    'et',
    'fi',
    'ru',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      showArrow: false,
      child: Container(
        child: Icon(Icons.language, color: Colors.grey),
        padding: EdgeInsets.all(20),
      ),
      menuBuilder: () => Container(
        width: 167,
        height: 198,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            border: Border.all(color: Color(0XFFD3DEEA), width: 1),
            color: whiteColor,
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(4, (index) => index)
              .map(
                (index) => GestureDetector(
                  // behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (Localizations.localeOf(context).languageCode !=
                        codes[index]) {
                      changeLocale(
                        context,
                        codes[index],
                      );
                      var locale = Locale(codes[index], '');
                      Get.updateLocale(locale);
                    }
                    controller.hideMenu();
                  },
                  child: Container(
                    color: Localizations.localeOf(context).languageCode ==
                            codes[index]
                        ? primaryColor.withOpacity(.1)
                        : whiteColor,
                    height: 49,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.radio_button_off,
                          size: 15,
                          color: Localizations.localeOf(context).languageCode ==
                                  codes[index]
                              ? primaryColor
                              : hintColor,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              lans[index],
                              style: TextStyle(
                                  color: Localizations.localeOf(context)
                                              .languageCode ==
                                          codes[index]
                                      ? primaryColor
                                      : hintColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      pressType: PressType.singleClick,
      verticalMargin: -10,
      controller: controller,
    );

    // return IconButton(
    //   color: _color,
    //   iconSize: 24,
    //   onPressed: () => onActionSheetPress(context),
    //   icon: Icon(Icons.language),
    // );
  }
}
