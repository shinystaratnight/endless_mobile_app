import 'package:piiprent/constants.dart';

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
    result.addAll({languageMap['EN']: name});
  }

  return result;
}

String parseAddress(Map<String, dynamic> address) {
  if (address != null) {
    return (address['__str__'] as String).replaceAll('\n', ' ');
  }

  return null;
}

double doubleParse(dynamic target, [defaultValue = 0.00]) {
  if (target.runtimeType == String) {
    return double.parse(target);
  }

  return defaultValue;
}
