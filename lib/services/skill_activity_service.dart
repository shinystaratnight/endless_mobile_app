import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:piiprent/models/skill_activity_model.dart';
import 'package:piiprent/services/api_service.dart';

class SkillActivityBody {
  final String timesheet;
  final String worktype;
  final String skill;
  final double rate;
  final double value;

  SkillActivityBody({
    this.timesheet,
    this.worktype,
    this.skill,
    this.rate,
    this.value,
  });

  Map<String, dynamic> getRequestBody() {
    return {
      'timesheet': timesheet,
      'skill': {
        'id': skill,
      },
      'worktype': {
        'id': worktype,
      },
      'rate': rate,
      'value': value,
    };
  }
}

class SkillActivityService {
  final ApiService apiService = ApiService.create();

  Future<List<SkillActivity>> getSkillActivitiesByTimesheet(
      [Map<String, dynamic> query]) async {
    Map<String, dynamic> params = {};

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res =
        await apiService.get(path: '/hr/timesheetrates/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> results = body['results'];
      List<SkillActivity> skillActivities =
          results.map((dynamic el) => SkillActivity.fromJson(el)).toList();

      if (skillActivities.isNotEmpty) {
        skillActivities.insert(0, SkillActivity(id: ''));
      }

      return skillActivities;
    } else {
      throw Exception('Failed to load Skill Activities');
    }
  }

  Future<bool> createSkillActivity(SkillActivityBody body) async {
    http.Response res = await this.apiService.post(
          path: 'hr/timesheetrates/',
          body: body.getRequestBody(),
        );

    if (res.statusCode == 201) {
      return true;
    } else {
      String errorMessage;
      if (res.statusCode == 400) {
        Map<String, dynamic> responseBody = jsonDecode(res.body);
        errorMessage = responseBody['errors']['non_field_errors'][0];
      }
      throw Exception(errorMessage ?? 'Failed to create Skill Activity');
    }
  }

  Future<bool> removeSkillActivity(String id) async {
    http.Response res = await this.apiService.delete(
          path: 'hr/timesheetrates/$id/',
        );

    if (res.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete Skill Activity');
    }
  }
}
