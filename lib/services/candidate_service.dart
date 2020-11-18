import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:piiprent/models/candidate_model.dart';

import 'package:piiprent/services/api_service.dart';

class CandidateService {
  final ApiService apiService = ApiService.create();

  Future<Candidate> getCandidate(String id) async {
    Map<String, dynamic> params = {
      'fields': [
        'id',
        'average_score',
        'contact',
        'skill_list',
        'height',
        'weight',
        'bmi',
        'candidate_scores',
        'residency',
        'nationality',
        'visa_type',
        'visa_expiry_date',
        'tag_list'
      ],
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
}