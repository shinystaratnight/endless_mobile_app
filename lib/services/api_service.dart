import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:piiprent/models/auth_model.dart';

class ApiService {
  final String _baseUrl = 'api.r3sourcer.com';
  Auth _auth;
  final Map<String, dynamic> _emptyMap = Map();

  set auth(Auth auth) {
    this._auth = auth;
  }

  get auth {
    return this._auth;
  }

  Future get({String path, Map<String, dynamic> params}) async {
    Uri uri = _createURI(path, params);
    Map<String, String> headers = {};
    _updateByToken(headers);

    return await http.get(uri, headers: headers);
  }

  Future post({String path, Map<String, dynamic> body}) async {
    Uri uri = _createURI(path, _emptyMap);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    _updateByToken(headers);

    String bodyEncoded = json.encode(body);

    return await http.post(uri, headers: headers, body: bodyEncoded);
  }

  Uri _createURI(String path, Map<String, dynamic> params) {
    return Uri(
      scheme: 'https',
      host: _baseUrl,
      path: path,
      queryParameters: params,
    );
  }

  void _updateByToken(headers) {
    if (this.auth != null) {
      headers.addAll({HttpHeaders.authorizationHeader: 'Bearer $this.token'});
    }
  }
}
