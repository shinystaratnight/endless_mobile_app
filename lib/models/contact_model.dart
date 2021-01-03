class Contact {
  final String id;
  final Map<String, dynamic> picture;
  final String firstName;
  final String lastName;
  final String title;
  final String email;
  final String phoneMobile;

  Contact({
    this.id,
    this.picture,
    this.firstName,
    this.lastName,
    this.title,
    this.email,
    this.phoneMobile,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      picture: json['picture'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      title: json['title'],
      email: json['email'],
      phoneMobile: json['phone_mobile'],
    );
  }

  String userAvatarUrl() {
    if (picture != null && picture['origin'] != null) {
      return picture['origin'];
    }

    return null;
  }

  String get fullName {
    return '$title $firstName $lastName';
  }
}
