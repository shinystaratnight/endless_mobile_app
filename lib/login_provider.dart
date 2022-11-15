import 'package:flutter/cupertino.dart';

class LoginProvider extends ChangeNotifier{

  int _switchRole=0;
  int get switchRole => _switchRole;

  set switchRole(val){
    _switchRole = val;
    notifyListeners();
  }

  String _image;

  String get image => _image;
  set image(value){
    _image =value;
    notifyListeners();
  }
}