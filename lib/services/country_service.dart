import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:piiprent/models/country_model.dart';
import 'package:piiprent/services/api_service.dart';

class CountryService {
  final ApiService apiService = ApiService.create();

  Future<List<Country>> getCountries([Map<String, dynamic> query]) async {
    Map<String, dynamic> params = {
      'fields': Country.requestFields,
      'limit': '-1'
    };

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res =
        await apiService.get(path: '/core/countries/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> results = body['results'];
      List<Country> countries =
          results.map((dynamic el) => Country.fromJson(el)).toList();

      return countries;
    } else {
      throw Exception('Failed to load Countries');
    }
  }
}
