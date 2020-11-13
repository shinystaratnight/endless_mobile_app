class Skill {
  final String id;
  final String name;
  final List<dynamic> translations;

  Skill({this.id, this.name, this.translations});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] as String,
      name: json['__str__'] as String,
      translations: json['translations'] as List<dynamic>,
    );
  }
}
