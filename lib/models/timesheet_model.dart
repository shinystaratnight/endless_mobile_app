import 'package:piiprent/helpers/functions.dart';

class Timesheet {
  final String id;
  final String clientContact;
  final Map<String, dynamic> translations;
  final String company;
  final String address;
  final String jobsite;
  final DateTime shiftStart;
  final DateTime shiftEnd;
  final DateTime breakStart;
  final DateTime breakEnd;
  final int status;

  static final requestFields = [
    'id',
    'supervisor',
    'position',
    'company',
    'jobsite',
    'shift_started_at',
    'shift_ended_at',
    'break_started_at',
    'break_ended_at',
    'status',
  ];

  Timesheet({
    this.id,
    this.clientContact,
    this.translations,
    this.company,
    this.address,
    this.jobsite,
    this.shiftStart,
    this.shiftEnd,
    this.breakStart,
    this.breakEnd,
    this.status,
  });

  factory Timesheet.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> translations = {
      'position': generateTranslations(
        json['position']['translations'],
        json['position']['__str__'],
      ),
    };

    return Timesheet(
      id: json['id'],
      clientContact: json['supervisor']['name'],
      translations: translations,
      company: json['company']['__str__'],
      address: (json['jobsite']['address']['__str__'] as String)
          .replaceAll('\n', ' '),
      jobsite: json['jobsite']['__str__'],
      shiftStart: DateTime.parse(json['shift_started_at']),
      shiftEnd: DateTime.parse(json['shift_ended_at']),
      breakStart: DateTime.parse(json['break_started_at']),
      breakEnd: DateTime.parse(json['break_ended_at']),
      status: json['status'],
    );
  }

  get position {
    return translations['position']['en'];
  }
}

DateTime getDateTime(String date, String time) {
  return DateTime.parse('$date $time');
}
