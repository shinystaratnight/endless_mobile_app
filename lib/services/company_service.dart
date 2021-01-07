import 'package:piiprent/models/settings_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:piiprent/services/api_service.dart';

class CompanyService {
  final ApiService apiService = ApiService.create();

  Future<Settings> getSettings() async {
    try {
      http.Response res = await apiService.get(
        path: '/company_settings/site/',
      );

      if (res.statusCode == 200) {
        Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
        Settings settings = Settings.fromJson(body);

        return settings;
      } else {
        throw Exception('Failed to load company settings');
      }
    } catch (e) {
      return e;
    }
  }
}
