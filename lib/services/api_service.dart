import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:piiprent/constants.dart';
import 'package:piiprent/models/auth_model.dart';

ApiService instance;

class ApiService {
  final String _baseUrl = apiUrl.replaceAll('https://', '');
  Auth _auth;
  final Map<String, dynamic> _emptyMap = Map();

  set auth(Auth auth) {
    this._auth = auth;
  }

  get auth {
    return this._auth;
  }

  ApiService();

  factory ApiService.create() {
    if (instance != null) {
      return instance;
    } else {
      instance = ApiService();
      return instance;
    }
  }

  Future get({String path, Map<String, dynamic> params}) async {
    Uri uri = _createURI(path, params);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      // TODO: check this for getting industries or skills
      'Origin': 'laviin.r3sourcertest.com'
    };
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

  Future put({String path, Map<String, dynamic> body}) async {
    Uri uri = _createURI(path, _emptyMap);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    _updateByToken(headers);

    String bodyEncoded = json.encode(body);

    return await http.put(uri, headers: headers, body: bodyEncoded);
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
    if (auth != null) {
      headers.addAll({
        HttpHeaders.authorizationHeader: 'JWT ${auth.access_token_jwt}',
      });
    }
  }
}
