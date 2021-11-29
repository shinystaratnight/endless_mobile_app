import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:piiprent/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, String> generateTranslations(
  List<dynamic> translations,
  String name,
) {
  Map<String, String> result = Map();

  if (translations.isEmpty) {
    result.addAll({languageMap['EN']: name});
  } else {
    translations.forEach((element) {
      result.addAll({element['language']['id']: element['value']});
    });

    if (result[languageMap['EN']] == null) {
      result.addAll({languageMap['EN']: name});
    }
  }

  return result;
}

String parseAddress(Map<String, dynamic> address) {
  if (address != null) {
    return (address['__str__'] as String).replaceAll('\n', ' ');
  }

  return '';
}

double doubleParse(dynamic target, [defaultValue = 0.00]) {
  if (target.runtimeType == String) {
    return double.parse(target);
  }

  return defaultValue;
}

void showProminentDisclosureDialog(
    BuildContext context, Function action) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('isPermissionAllowed') == true) {
    var status = await Permission.location.status;
    if (status.isGranted) {
      action(true);
      return;
    }
  }
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            title: Text('Prominent disclosure'),
            content: Text(
                'Piiprent collects location data to track your job progress when you have started the Job from the App even when the app is in background\nThis app not functional without location permission.'),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  action(false);
                },
                child: Text('Deny'),
              ),
              MaterialButton(
                onPressed: () {
                  prefs.setBool('isPermissionAllowed', true);
                  Navigator.pop(context);
                  action(true);
                },
                child: Text('Agree'),
              ),
            ],
          ));
    },
  );
}

void showDenyAlertDialog(BuildContext context, Function action) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
                "When you are going to work and have active shift, we can tracking work location for the confirmation without this permission you're not eligible for this work"),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  action(false);
                },
                child: Text('Close'),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  action(true);
                },
                child: Text('Allow'),
              ),
            ],
          ));
    },
  );
}
