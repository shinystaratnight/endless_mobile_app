import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/helpers/jwt_decode.dart';
import 'package:piiprent/models/auth_model.dart';
import 'package:piiprent/models/user_model.dart';
import 'package:piiprent/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final ApiService apiService = ApiService.create();
  User _user;

  User get user {
    return _user;
  }

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

      if (res.statusCode == 400) {
        throw 'Invalid credentials given.';
      }

      if (res.statusCode != 200) {
        throw 'Something went wrong';
      }

      Auth auth = Auth.fromJson(json.decode(res.body));
      apiService.auth = auth;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('auth', res.body);

      var payload = parseJwtPayLoad(auth.access_token_jwt);
      _user = User.fromTokenPayload(payload);

      return _user.type;
    } catch (e) {
      throw e;
    }
  }

  Future<Role> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authEncoded = (prefs.getString('auth') ?? '');

    if (authEncoded != '') {
      Auth auth = Auth.fromJson(json.decode(authEncoded));
      var payload = parseJwtPayLoad(auth.access_token_jwt);
      DateTime expireDateTime =
          DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);

      if (DateTime.now().isAfter(expireDateTime)) {
        await logout();
        return null;
        // TODO: implement refresh token
        // var res = await refreshToken(auth);
      }
      apiService.auth = auth;
      _user = User.fromTokenPayload(payload);

      return _user.type;
    } else {
      return null;
    }
  }

  Future refreshToken(Auth auth) async {
    var payload = parseJwtPayLoad(auth.access_token_jwt);
    User user = User.fromTokenPayload(payload);

    Map<String, String> body = {
      'username': user.email,
      'grant_type': 'refresh_token',
      'refresh_token': auth.refresh_token,
      'client_id': clientId,
    };

    try {
      http.Response res =
          await apiService.post(path: '/oauth2/token/', body: body);

      return res;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _user = null;
    apiService.auth = null;
    return true;
  }
}
