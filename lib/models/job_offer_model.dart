class JobOffer {
  final String id;
  final String company;
  final DateTime datetime;
  final String position;
  final String longitude;
  final String latitude;
  final String location;
  final String timezone;
  final String clientContact;

  JobOffer({
    this.id,
    this.company,
    this.datetime,
    this.position,
    this.longitude,
    this.latitude,
    this.location,
    this.timezone,
    this.clientContact,
  });

  factory JobOffer.fromJson(Map<String, dynamic> json) {
    var date = json['shift']['date'];
    var job = date['job'];
    var address = json['jobsite_address'];

    return JobOffer(
      id: json['id'],
      company: job['customer_company']['__str__'],
      position: job['position']['name'],
      datetime: getDateTime(date['shift_date'], json['shift']['time']),
      longitude: address['longitude'],
      latitude: address['latitude'],
      timezone: job['customer_company']['timezone'],
      location: (address['__str__'] as String).replaceAll('\n', ' '),
      clientContact: job['jobsite']['primary_contact']['name'],
    );
  }
}

DateTime getDateTime(String date, String time) {
  return DateTime.parse('$date $time');
}
