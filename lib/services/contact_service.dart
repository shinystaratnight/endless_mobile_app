import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:piiprent/constants.dart';
import 'package:piiprent/models/api_error_model.dart';
import 'package:piiprent/models/client_contact_model.dart';
import 'package:piiprent/models/role_model.dart';

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

  Future<String> changePassowrd({
    String oldPass,
    String newPass,
    String confirmPass,
    String id,
  }) async {
    var body = {
      'old_password': oldPass,
      'password': newPass,
      'confirm_password': confirmPass,
    };

    http.Response res = await apiService.put(
      path: '/core/contacts/$id/change_password/',
      body: body,
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));

      return body['message'];
    } else {
      throw Exception("Password was not change");
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
    gender,
    residency,
    nationality,
    transport,
    height,
    weight,
    bankAccountName,
    bankName,
    iban,
    tags,
    address,
  }) async {
    var body = {
      'contact': {
        'title': title,
        'first_name': firstName,
        'last_name': lastName,
        'birthday': birthday,
        'phone_mobile': phone,
        'email': email,
        'bank_accounts': {
          'AccountholdersName': bankAccountName,
          'IBAN': iban,
          'bank_name': bankName,
        },
        'gender': gender,
        'address': {'street_address': address}
      },
      'height': height,
      'weight': weight,
      'nationality': {'id': nationality},
      'transportation_to_work': transport,
      'residency': residency,
      'industry': {'id': industry},
      'skill': skills,
      'tag': tags,
    };

    http.Response res = await apiService.post(
      path: 'core/forms/$formId/submit/',
      body: body,
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      var error = ApiError.fromJson(json.decode(res.body));
      throw Exception(error.messages.join(' '));
    }
  }

  Future getRoles() async {
    try {
      http.Response res = await apiService.get(path: '/core/users/roles/');

      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> roles = body['roles'];
      return roles.map((dynamic el) => Role.fromJson(el)).toList();
    } catch (e) {
      throw Exception("Failed fetching roles");
    }
  }

  Future getCompanyContactDetails(String id) async {
    try {
      http.Response res =
          await apiService.get(path: '/core/companycontacts/$id/');

      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      return ClientContact.fromJson(body);
    } catch (e) {
      throw Exception("Failed fetching roles");
    }
  }

  Future getContactPicture(String id) async {
    Map<String, dynamic> params = {
      'fields': ['picture'],
    };

    try {
      http.Response res = await apiService.get(
        path: '/core/contacts/$id/',
        params: params,
      );

      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      var picture = body['picture'];

      return picture != null ? picture['origin'] : null;
    } catch (e) {
      throw Exception("Failed fetching roles");
    }
  }
}
