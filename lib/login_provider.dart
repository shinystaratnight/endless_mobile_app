import 'package:flutter/cupertino.dart';
import 'package:piiprent/screens/preview_screen.dart';

class LoginProvider extends ChangeNotifier{
  var cacheManager =CustomCacheManager.instance;
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