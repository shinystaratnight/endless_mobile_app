class Settings {
  final String id;
  final String countryCode;
  final String company;

  Settings({
    this.id,
    this.countryCode,
    this.company,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      id: json['id'],
      countryCode: json['country_code'],
      company: json['company'],
    );
  }
}
