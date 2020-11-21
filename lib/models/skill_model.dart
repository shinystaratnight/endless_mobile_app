import 'package:piiprent/helpers/functions.dart';

class Skill {
  final String id;
  final Map<String, Map<String, String>> translations;

  static final requestFields = [
    'id',
    'name',
  ];

  Skill({
    this.id,
    this.translations,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    Map<String, Map<String, String>> translations = {
      'name': generateTranslations(
        json['name']['translations'],
        json['name']['__str__'],
      )
    };

    return Skill(
      id: json['id'],
      translations: translations,
    );
  }

  String get name {
    return translations['name']['en'];
  }
}
