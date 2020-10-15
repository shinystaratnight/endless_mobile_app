class Industry {
  final String id;
  final String name;
  final List<dynamic> translations;

  Industry({this.id, this.name, this.translations});

  factory Industry.fromJson(Map<String, dynamic> json) {
    return Industry(
      id: json['id'] as String,
      name: json['__str__'] as String,
      translations: json['translations'] as List<dynamic>,
    );
  }
}
