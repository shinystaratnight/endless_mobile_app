import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/functions.dart';
import 'package:piiprent/models/average_scores_model.dart';
import 'package:piiprent/models/candidate_skill_model.dart';
import 'package:piiprent/models/candidate_tag_model.dart';

class Candidate {
  final String id;
  final String averageScore;
  final String address;
  final List<CandidateSkill> skills;
  final String designation;
  final String firstName;
  final String lastName;
  final String height;
  final String weight;
  final String bmi;
  final DateTime birthday;
  final String email;
  final String phone;
  final AverageScores averageScores;
  final String residency;
  final String nationality;
  final String visaType;
  final DateTime visaExpiryDate;
  final List<CandidateTag> tags;

  Candidate({
    this.id,
    this.averageScore,
    this.address,
    this.skills,
    this.designation,
    this.firstName,
    this.lastName,
    this.height,
    this.weight,
    this.bmi,
    this.birthday,
    this.email,
    this.phone,
    this.averageScores,
    this.residency,
    this.nationality,
    this.visaType,
    this.visaExpiryDate,
    this.tags,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    var contact = json['contact'];
    List<CandidateSkill> skills = (json['skill_list'] as List<dynamic>)
        .map((e) => CandidateSkill.fromJson(e))
        .toList();
    List<CandidateTag> tags = (json['tag_list'] as List<dynamic>)
        .map((e) => CandidateTag.fromJson(e))
        .toList();
    String designation;
    if (skills.length > 0) {
      skills.sort((a, b) => a.score.compareTo(b.score));
      designation = skills[0].skill.name;
    }

    return Candidate(
      id: json['id'],
      averageScore: json['average_score'],
      address: parseAddress(contact['address']),
      skills: skills,
      designation: designation,
      firstName: contact['first_name'],
      lastName: contact['last_name'],
      height: json['height'],
      weight: json['weight'],
      bmi: json['bmi'],
      birthday: contact['birthday'] != null
          ? DateTime.parse(contact['birthday'])
          : null,
      email: contact['email'],
      phone: contact['phone_mobile'],
      averageScores: AverageScores.fromJson(json['candidate_scores']),
      residency: json['residency'] != null ? Residency[json['residency']] : '',
      nationality:
          json['nationality'] != null ? json['nationality']['__str__'] : '',
      visaType: json['visa_type'] != null ? json['visa_type']['__str__'] : '',
      visaExpiryDate: json['visa_expiry_date'] != null
          ? DateTime.parse(json['visa_expiry_date'])
          : null,
      tags: tags,
    );
  }
}
