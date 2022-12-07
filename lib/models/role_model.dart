class Role {
  final String id;
  final String name;
  final String roleUserName;
  final String companyId;
  final String clientContactId;

  bool active;

  static final requestFields = [
    'id',
    '__str__',
  ];

  Role({this.id, this.name, this.companyId, this.clientContactId,this.roleUserName});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: (json['__str__'] as String).split('-')[0].trim(),
      roleUserName:(json['__str__'] as String).split('-')[1].trim() ,
      companyId: json['company_id'],
      clientContactId: json['client_contact_id'],
    );
  }
}
