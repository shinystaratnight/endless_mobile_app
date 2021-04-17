class Worktype {
  String name;
  String id;

  static final List<String> requestFields = ['name', 'id', 'uom'];

  Worktype({
    this.name,
    this.id,
  });

  factory Worktype.fromJson(Map<String, dynamic> payload) {
    return Worktype(
      name: payload['name'],
      id: payload['id'],
    );
  }
}
