class Settings {
  final String id;
  final String countryCode;

  Settings({
    this.id,
    this.countryCode,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      id: json['id'],
      countryCode: json['country_code'],
    );
  }
}
