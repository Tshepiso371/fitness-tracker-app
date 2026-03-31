import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    // Gate 1 — Is GPS hardware enabled?
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled. Please enable GPS in your device settings.';
    }

    // Gate 2 — Does this app have permission?
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permission denied. Tap Start Run to try again.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permission is permanently denied. Please enable it in your device settings.';
    }

    // Gate 3 — Fetch coordinates
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  double calculateDistance(double startLat, double startLon, double endLat, double endLon) {
    return Geolocator.distanceBetween(startLat, startLon, endLat, endLon);
  }
}
