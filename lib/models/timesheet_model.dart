import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/functions.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;

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
  final Map<String, dynamic> candidate;
  final String score;
  final bool evaluated;
  final bool signatureScheme;
  final Map<String, dynamic> supervisorSignature;

  static final requestFields = [
    'id',
    'supervisor',
    'position',
    'company',
    'jobsite',
    'shift_started_at_tz',
    'shift_ended_at_tz',
    'break_started_at_tz',
    'break_ended_at_tz',
    'status',
    'job_offer',
    'evaluated',
    'supervisor_signature',
    'time_zone',
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
    this.candidate,
    this.score,
    this.evaluated,
    this.signatureScheme,
    this.supervisorSignature,
  });

  factory Timesheet.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> translations = {
      'position': generateTranslations(
        json['position']['translations'],
        json['position']['__str__'],
      ),
    };

    Map<String, dynamic> candidateContact =
        json['job_offer']['candidate_contact'];

    Map<String, dynamic> company = json['company'];

    return Timesheet(
      id: json['id'],
      clientContact: json['supervisor']['name'],
      translations: translations,
      company: company['__str__'],
      address: (json['jobsite']['address']['__str__'] as String)
          .replaceAll('\n', ' '),
      jobsite: json['jobsite']['__str__'],
      shiftStart:
          parseWithTimeZone(json['time_zone'], json['shift_started_at_tz']),
      shiftEnd: parseWithTimeZone(json['time_zone'], json['shift_ended_at_tz']),
      breakStart:
          parseWithTimeZone(json['time_zone'], json['break_started_at_tz']),
      breakEnd: parseWithTimeZone(json['time_zone'], json['break_ended_at_tz']),
      status: json['status'],
      candidate: candidateContact['contact'],
      score: candidateContact['candidate_scores']['average_score'],
      evaluated: json['evaluated'],
      signatureScheme: company['supervisor_approved_scheme'] == 'SIGNATURE',
      supervisorSignature: json['supervisor_signature'],
    );
  }

  get position {
    return translations['position']['en'];
  }

  String get candidateAvatarUrl {
    if (candidate['picture']['origin'] != null) {
      return '$apiUrl${candidate['picture']['origin']}';
    }

    return null;
  }

  String get candidateName {
    if (candidate['__str__'] != null) {
      return candidate['__str__'];
    }

    return null;
  }

  String get signatureUrl {
    if (supervisorSignature['origin'] != null) {
      return '$apiUrl${supervisorSignature['origin']}';
    }

    return null;
  }
}

DateTime getDateTime(String date, String time) {
  return DateTime.parse('$date $time');
}

DateTime parseWithTimeZone(String timezone, String target) {
  tz.initializeTimeZones();

  return TZDateTime.from(DateTime.parse(target), getLocation(timezone));
}
