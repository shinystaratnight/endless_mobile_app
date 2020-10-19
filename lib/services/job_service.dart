import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/services/api_service.dart';

class JobService {
  final ApiService apiService = ApiService.create();

  Future getCandidateJobs() async {
    Map<String, dynamic> params = {
      'status': '1',
    };

    http.Response res =
        await apiService.get(path: '/hr/joboffers-candidate/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(res.body);
      List<dynamic> results = body['results'];
      List<JobOffer> jobs =
          results.map((dynamic el) => JobOffer.fromJson(el)).toList();

      return jobs;
    } else {
      throw Exception('Failed to load Job Offers');
    }
  }
}
