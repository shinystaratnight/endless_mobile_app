import 'package:flutter/material.dart';
import 'package:piiprent/mixins/change_language.dart';

class LanguageSelect extends StatelessWidget with ChangeLanguage {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => onActionSheetPress(context),
      child: Text('Language'),
    );
  }
}
