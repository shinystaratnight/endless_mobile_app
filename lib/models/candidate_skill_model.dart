import 'package:piiprent/models/skill_model.dart';

class CandidateSkill {
  final String id;
  final int score;
  final Skill skill;

  CandidateSkill({this.id, this.score, this.skill});

  factory CandidateSkill.fromJson(Map<String, dynamic> json) {
    return CandidateSkill(
      id: json['id'],
      score: json['score'],
      skill: Skill.fromJson(json['skill']),
    );
  }
}
