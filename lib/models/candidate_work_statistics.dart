class CandidateWorkState {
  String id;
  String sStr;
  int shiftsTotal;
  HourlyWork hourlyWork;
  SkillActivities skillActivities;
  String currency;

  CandidateWorkState(
      {this.id,
        this.sStr,
        this.shiftsTotal,
        this.hourlyWork,
        this.skillActivities,
        this.currency});

  CandidateWorkState.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sStr = json['__str__'];
    shiftsTotal = json['shifts_total'];
    hourlyWork = json['hourly_work'] != null
        ? new HourlyWork.fromJson(json['hourly_work'])
        : null;
    skillActivities = json['skill_activities'] != null
        ? new SkillActivities.fromJson(json['skill_activities'])
        : null;
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['__str__'] = this.sStr;
    data['shifts_total'] = this.shiftsTotal;
    if (this.hourlyWork != null) {
      data['hourly_work'] = this.hourlyWork.toJson();
    }
    if (this.skillActivities != null) {
      data['skill_activities'] = this.skillActivities.toJson();
    }
    data['currency'] = this.currency;
    return data;
  }
}

class HourlyWork {
  double totalHours;
  int totalMinutes;
  int totalEarned;

  HourlyWork({this.totalHours, this.totalMinutes, this.totalEarned});

  HourlyWork.fromJson(Map<String, dynamic> json) {
    totalHours = json['total_hours'];
    totalMinutes = json['total_minutes'];
    totalEarned = json['total_earned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_hours'] = this.totalHours;
    data['total_minutes'] = this.totalMinutes;
    data['total_earned'] = this.totalEarned;
    return data;
  }
}

class SkillActivities {
  int totalEarned;

  SkillActivities({this.totalEarned});

  SkillActivities.fromJson(Map<String, dynamic> json) {
    totalEarned = json['total_earned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_earned'] = this.totalEarned;
    return data;
  }
}
