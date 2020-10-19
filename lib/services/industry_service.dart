import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:piiprent/constants.dart';
import 'package:piiprent/models/industry_model.dart';
import 'package:piiprent/services/api_service.dart';

class IndustryService {
  final ApiService apiService = ApiService.create();

  Future<List<Industry>> getIndustries() async {
    Map<String, dynamic> params = {
      'limit': '-1',
      'fields': ['id', '__str__', 'translations'],
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
}
