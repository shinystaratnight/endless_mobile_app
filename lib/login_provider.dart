import 'package:flutter/cupertino.dart';

class LoginProvider extends ChangeNotifier{

  String _image;

  String get image => _image;
  set image(value){
    _image =value;
    notifyListeners();
  }
}