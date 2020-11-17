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
