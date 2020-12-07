import 'package:geolocator/geolocator.dart';

class TrackingService {
  Future<Position> getCurrentPosition() async {
    try {
      bool enabled = await Geolocator.isLocationServiceEnabled();

      if (!enabled) {
        Geolocator.openLocationSettings();
      }

      return Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<LocationPermission> requestPermission() async {
    try {
      LocationPermission locationPermission =
          await Geolocator.checkPermission();

      if (locationPermission == LocationPermission.deniedForever) {
        return null;
      }

      if (locationPermission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      return locationPermission;
    } catch (e) {
      print(e);
      return e;
    }
  }
}
