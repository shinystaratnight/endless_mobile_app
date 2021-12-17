class Country {
  final String id;
  final String str;

  static final requestFields = [
    'id',
    '__str__',
  ];

  Country({
    this.id,
    this.str,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      str: json['__str__'],
    );
  }

  String get name {
    return this.str;
  }
}
