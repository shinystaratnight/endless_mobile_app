import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:piiprent/helpers/jwt_decode.dart';
import 'package:piiprent/models/auth_model.dart';
import 'package:piiprent/models/user_model.dart';
import 'package:piiprent/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:location/location.dart';

Location location = new Location();

class TrackingService {
  final ApiService apiService = ApiService.create();

  Future getCurrentPosition() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  Future<bool> sendLocation(Position position, String timesheetId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authEncoded = (prefs.getString('auth') ?? '');

    if (authEncoded == '') {
      return false;
    }

    Auth auth = Auth.fromJson(json.decode(authEncoded));
    var payload = parseJwtPayLoad(auth.access_token_jwt);

    User user = User.fromTokenPayload(payload);

    Map<String, dynamic> body = {
      'locations': [
        {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timesheet_id': timesheetId,
          'name': user.name,
          // 'log_at': DateTime.now().subtract(Duration(hours: 10)).toUtc().toString()
        }
      ]
    };

    try {
      Response res = await this.apiService.put(
            path: 'candidate/location/${user.candidateId}/',
            body: body,
          );

      if (res.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
