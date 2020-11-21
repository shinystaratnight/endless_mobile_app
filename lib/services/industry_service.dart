import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:piiprent/constants.dart';
import 'package:piiprent/models/industry_model.dart';
import 'package:piiprent/models/skill_model.dart';
import 'package:piiprent/services/api_service.dart';

class IndustryService {
  final ApiService apiService = ApiService.create();

  Future<List<Industry>> getIndustries() async {
    Map<String, dynamic> params = {
      'limit': '-1',
      'fields': Industry.requestFields,
      'company': companyId,
    };

    http.Response res = await apiService.get(
      path: '/pricing/industries/',
      params: params,
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(res.body);
      List<dynamic> results = body['results'];
      List<Industry> industries =
          results.map((dynamic el) => Industry.fromJson(el)).toList();

      return industries;
    } else {
      throw Exception('Failed to load Industries');
    }
  }

  Future<List<Skill>> getSkills(String industry) async {
    Map<String, dynamic> params = {
      'limit': '-1',
      'fields': Skill.requestFields,
      'industry': industry,
    };

    http.Response res = await apiService.get(
      path: '/skills/skills/',
      params: params,
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(res.body);
      List<dynamic> results = body['results'];
      List<Skill> skills =
          results.map((dynamic el) => Skill.fromJson(el)).toList();

      return skills;
    } else {
      throw Exception('Failed to load Skills');
    }
  }
}
