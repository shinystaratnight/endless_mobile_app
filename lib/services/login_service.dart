import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/helpers/jwt_decode.dart';
import 'package:piiprent/models/auth_model.dart';
import 'package:piiprent/models/industry_model.dart';
import 'package:piiprent/models/user_model.dart';
import 'package:piiprent/services/api_service.dart';

class LoginService {
  final ApiService apiService = ApiService.create();
  User user;

  Future<Role> login(String username, String password) async {
    Map<String, dynamic> body = {
      'client_id': clientId,
      'username': username,
      'password': password,
      'grant_type': 'password'
    };

    try {
      http.Response res =
          await apiService.post(path: '/oauth2/token/', body: body);

      print(res.body);

      if (res.statusCode == 400) {
        throw 'Invalid credentials given.';
      }

      if (res.statusCode != 200) {
        throw 'Something went wrong';
      }

      Auth auth = Auth.fromJson(json.decode(res.body));
      apiService.auth = auth;
      var payload = parseJwtPayLoad(auth.access_token_jwt);
      user = User.fromTokenPayload(payload);

      return user.type;
    } catch (e) {
      throw e;
    }
  }

  bool logout() {
    user = null;
    apiService.auth = null;
    return true;
  }
}
