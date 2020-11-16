import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/services/api_service.dart';

class TimesheetService {
  final ApiService apiService = ApiService.create();

  Future getCandidateTimesheets([Map<String, dynamic> query]) async {
    Map<String, dynamic> params = {};

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res =
        await apiService.get(path: '/hr/timesheets-candidate/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(res.body);
      List<dynamic> results = body['results'];
      List<Timesheet> timesheets =
          results.map((dynamic el) => Timesheet.fromJson(el)).toList();

      return {"list": timesheets, "count": body["count"]};
    } else {
      throw Exception('Failed to load Timesheets');
    }
  }

  Future<bool> acceptPreShiftCheck(String id) async {
    Map<String, dynamic> body = Map();

    http.Response res = await this
        .apiService
        .post(path: 'hr/timesheets/$id/confirm/', body: body);

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to accept Pre-shift check');
    }
  }

  Future<bool> declinePreShiftCheck(String id) async {
    Map<String, dynamic> body = Map();

    http.Response res = await this
        .apiService
        .post(path: 'hr/timesheets/$id/decline/', body: body);

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to decline Pre-shift check');
    }
  }
}
