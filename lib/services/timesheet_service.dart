import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/services/api_service.dart';

class TimesheetService {
  final ApiService apiService = ApiService.create();

  Future getActiveTimeheets() async {
    Map<String, dynamic> params = {
      'fields': Timesheet.requestFields,
      'shift_started_at_0': DateFormat('yyyy-MM-dd').format(
        DateTime.now().subtract(Duration(days: 1)),
      ),
    };

    http.Response res =
        await apiService.get(path: '/hr/timesheets-candidate/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(res.body);
      List<dynamic> results = body['results'];
      List<Timesheet> timesheets =
          results.map((dynamic el) => Timesheet.fromJson(el)).toList();

      return timesheets.map((Timesheet timesheet) {
        return {
          'from': timesheet.shiftStart
              .subtract(Duration(hours: 1))
              .toUtc()
              .toString(),
          'to':
              timesheet.shiftStart.add(Duration(hours: 15)).toUtc().toString(),
          'id': timesheet.id,
        };
      }).toList();
    } else {
      throw Exception('Failed to load Active Timesheets');
    }
  }

  Future getCandidateTimesheets([Map<String, dynamic> query]) async {
    Map<String, dynamic> params = {
      'fields': Timesheet.requestFields,
    };

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

  Future getUnapprovedTimesheets([Map<String, dynamic> query]) async {
    Map<String, dynamic> params = {
      'fields': Timesheet.requestFields,
    };

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res = await apiService.get(
        path: '/hr/timesheets/unapproved/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(res.body);
      List<dynamic> results = body['results'];
      List<Timesheet> timesheets =
          results.map((dynamic el) => Timesheet.fromJson(el)).toList();

      return {"list": timesheets, "count": body["count"]};
    } else {
      throw Exception('Failed to load unapproved Timesheets');
    }
  }

  Future getHistoryTimesheets([Map<String, dynamic> query]) async {
    Map<String, dynamic> params = {
      'fields': Timesheet.requestFields,
    };

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res =
        await apiService.get(path: '/hr/timesheets/history/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(res.body);
      List<dynamic> results = body['results'];
      List<Timesheet> timesheets =
          results.map((dynamic el) => Timesheet.fromJson(el)).toList();

      return {"list": timesheets, "count": body["count"]};
    } else {
      throw Exception('Failed to load approved Timesheets');
    }
  }

  Future getCandidatePreShiftTimesheets([Map<String, dynamic> query]) async {
    Map<String, dynamic> params = {
      "status": '1',
      'fields': Timesheet.requestFields,
    };

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
      throw Exception('Failed to load pre shift Timesheets');
    }
  }

  Future<int> getCandidatePreShiftTimesheetsCount() async {
    Map<String, dynamic> params = {
      "status": '1',
      'limit': '-1',
      'fields': ['id'],
    };

    http.Response res =
        await apiService.get(path: '/hr/timesheets-candidate/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(res.body);
      int count = body['count'];

      return count;
    } else {
      throw Exception('Failed to load pre shift timesheets count');
    }
  }

  Future getCandidateForSubmitTimesheets([Map<String, dynamic> query]) async {
    Map<String, dynamic> params = {
      'status': '4',
      'fields': Timesheet.requestFields,
    };

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

  Future<int> getCandidateForSubmitTimesheetsCount() async {
    Map<String, dynamic> params = {
      'status': '4',
      'limit': '-1',
      'fields': ['id'],
    };

    http.Response res =
        await apiService.get(path: '/hr/timesheets-candidate/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(res.body);
      int count = body['count'];

      return count;
    } else {
      throw Exception('Failed to load submit timesheets count');
    }
  }

  Future getNotificationTimesheets([Map<String, dynamic> query]) async {
    var preShiftTimesheets =
        await getCandidatePreShiftTimesheets({'limit': '-1'});
    var submitTimesheets =
        await getCandidateForSubmitTimesheets({'limit': '-1'});

    preShiftTimesheets['list'].addAll(submitTimesheets['list']);

    return {
      "list": preShiftTimesheets['list'],
      "count": preShiftTimesheets['list'].length
    };
  }

  Future<bool> acceptPreShiftCheck(String id) async {
    Map<String, dynamic> body = Map();

    http.Response res = await this.apiService.post(
          path: 'hr/timesheets/$id/confirm/',
          body: body,
        );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to accept Pre-shift check');
    }
  }

  Future<bool> declinePreShiftCheck(String id) async {
    Map<String, dynamic> body = Map();

    http.Response res = await this.apiService.post(
          path: 'hr/timesheets/$id/decline/',
          body: body,
        );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to decline Pre-shift check');
    }
  }

  Future<bool> submitTimesheet(String id, body) async {
    http.Response res = await this.apiService.put(
          path: 'hr/timesheets-candidate/$id/submit/',
          body: body,
        );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to submit Timesheet');
    }
  }

  Future<bool> approveTimesheet(
    String id,
    Map<String, dynamic> body,
    bool updated,
  ) {
    if (updated) {
      return _notAgree(id, body);
    } else {
      if (body.containsKey('supervisor_signature')) {
        return _approveBySignature(id, body['supervisor_signature']);
      } else {
        return _approve(id);
      }
    }
  }

  Future<bool> evaluate(String id, int score) async {
    http.Response res = await this.apiService.put(
      path: '/hr/timesheets/$id/evaluate/',
      body: {'evaluation_score': score},
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to evaluate Timesheet');
    }
  }

  Future<bool> _approve(String id) async {
    http.Response res = await this.apiService.put(
          path: '/hr/timesheets/$id/approve/',
          body: Map(),
        );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to approve Timesheet');
    }
  }

  Future<bool> _approveBySignature(String id, String signature) async {
    http.Response res = await this.apiService.post(
      path: '/hr/timesheets/$id/approve_by_signature/',
      body: {'supervisor_signature': signature},
    );

    if (res.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to approve by signature Timesheet');
    }
  }

  Future<bool> _notAgree(String id, Map<String, dynamic> body) async {
    http.Response res = await this.apiService.put(
          path: '/hr/timesheets/$id/not_agree/',
          body: body,
        );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to change timesheet times');
    }
  }
}
