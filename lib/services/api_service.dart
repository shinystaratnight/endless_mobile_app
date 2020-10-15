import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'api.r3sourcer.com';
  String _token = '';

  set token(String token) {
    this._token = token;
  }

  get token {
    return this._token;
  }

  Future get({String path, Map<String, dynamic> params}) async {
    var uri = Uri(
        scheme: 'https', host: _baseUrl, path: path, queryParameters: params);
    Map<String, String> headers = {};

    print(uri);

    if (this.token != '') {
      headers.addAll({HttpHeaders.authorizationHeader: 'Bearer $this.token'});
    }

    return await http.get(uri);
  }
}
