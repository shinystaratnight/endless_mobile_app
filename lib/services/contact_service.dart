// import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:piiprent/constants.dart';

import 'package:piiprent/services/api_service.dart';

class ContactService {
  final ApiService apiService = ApiService.create();

  Future<bool> forgotPassowrd(String email) async {
    http.Response res = await apiService.post(
      path: '/core/contacts/forgot_password/',
      body: {'email': email},
    );

    if (res.statusCode == 200) {
      // Map<String, dynamic> body = json.decode(res.body);

      return true;
    } else {
      throw Exception("User with this email doesn't exist");
    }
  }

  Future<bool> register({
    title,
    email,
    phone,
    firstName,
    birthday,
    lastName,
    industry,
    skills,
  }) async {
    var body = {
      'contact': {
        'title': title,
        'first_name': firstName,
        'last_name': lastName,
        'birthday': birthday,
        'phone_mobile': phone,
        'email': email
      },
      'industry': {'id': industry},
      'skill': skills
    };

    http.Response res = await apiService.post(
      path: 'core/forms/$formId/submit/',
      body: body,
    );

    if (res.statusCode == 200) {
      // Map<String, dynamic> body = json.decode(res.body);

      return true;
    } else {
      throw Exception("User not registered");
    }
  }
}
