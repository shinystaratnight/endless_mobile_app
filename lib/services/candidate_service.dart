import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:piiprent/models/candidate_model.dart';
import 'package:piiprent/models/carrier_model.dart';

import 'package:piiprent/services/api_service.dart';

class CandidateService {
  final ApiService apiService = ApiService.create();

  Future<Candidate> getCandidate(String id) async {
    Map<String, dynamic> params = {
      'fields': Candidate.requestFields,
    };

    try {
      http.Response res = await apiService.get(
          path: 'candidate/candidatecontacts/$id/', params: params);

      if (res.statusCode == 200) {
        Map<String, dynamic> body = json.decode(res.body);
        Candidate candidate = Candidate.fromJson(body);

        return candidate;
      } else {
        throw Exception('Failed to load Candidate');
      }
    } catch (e) {
      return e;
    }
  }

  Future<List<Carrier>> getCandidateAvailability(String id) async {
    Map<String, dynamic> params = {
      'limit': '-1',
      'target_date_0': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'candidate_contact': id,
      'fields': Carrier.requestFields,
    };

    try {
      http.Response res =
          await apiService.get(path: 'hr/carrierlists/', params: params);

      if (res.statusCode == 200) {
        Map<String, dynamic> body = json.decode(res.body);
        List<dynamic> results = body['results'];
        List<Carrier> carriers =
            results.map((dynamic el) => Carrier.fromJson(el)).toList();

        return carriers;
      } else {
        throw Exception('Failed to load Carriers');
      }
    } catch (e) {
      return e;
    }
  }

  Future<Carrier> setAvailability(
      DateTime date, bool available, String id) async {
    Map<String, dynamic> body = {
      'confirmed_available': available,
      'target_date': DateFormat('yyyy-MM-dd').format(date),
      'candidate_contact': id,
    };

    try {
      http.Response res =
          await apiService.post(path: 'hr/carrierlists/', body: body);

      if (res.statusCode == 201) {
        Map<String, dynamic> body = json.decode(res.body);
        return Carrier.fromJson(body);
      } else {
        throw Exception('Failed set candidate availability');
      }
    } catch (e) {
      return e;
    }
  }

  Future<Carrier> updateAvailability(
    DateTime date,
    bool available,
    String userId,
    String id,
  ) async {
    Map<String, dynamic> body = {
      'confirmed_available': available,
      'target_date': DateFormat('yyyy-MM-dd').format(date),
      'candidate_contact': userId,
    };

    try {
      http.Response res =
          await apiService.put(path: 'hr/carrierlists/$id/', body: body);

      if (res.statusCode == 200) {
        Map<String, dynamic> body = json.decode(res.body);
        return Carrier.fromJson(body);
      } else {
        throw Exception('Failed update candidate availability');
      }
    } catch (e) {
      return e;
    }
  }
}
