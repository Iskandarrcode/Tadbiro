import 'package:geolocator/geolocator.dart';

class LocationService {
  static LocationPermission? permission;

  //!Qurilmaning Locatsiyaga ruxsatini tekshiradi va so'raydi

 static Future<bool> checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission != LocationPermission.deniedForever;
  }

  //! Qurilmaning joriy joylashuvini oladi
  static Future<Position?> determinePosition() async {
    if (permission != LocationPermission.deniedForever ||
        permission != LocationPermission.denied) {
      return await Geolocator.getCurrentPosition();
    }
    return null;
  }
}
