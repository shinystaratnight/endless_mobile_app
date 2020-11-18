import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/enums.dart';

class User {
  String name;
  String email;
  Role type;
  Map<String, dynamic> picture;
  String id;
  String userId;

  User({
    this.name,
    this.email,
    this.type,
    this.picture,
    // TODO: change name to candidate id
    this.id,
    this.userId,
  });

  factory User.fromTokenPayload(Map<String, dynamic> payload) {
    var contact = payload['contact'][0];

    return User(
      name: contact['name'],
      email: contact['email'],
      type: getRole(contact['contact_type']),
      picture: contact['picture'],
      id: contact['contact_id'],
      userId: contact['id'],
    );
  }

  String userAvatarUrl() {
    if (picture['origin'] != null) {
      return '$apiUrl${picture['origin']}';
    }

    return null;
  }
}

Role getRole(String contactType) {
  switch (contactType) {
    case 'candidate':
      return Role.Candidate;
    case 'client':
      return Role.Client;
    default:
      throw 'Unknown role';
  }
}
