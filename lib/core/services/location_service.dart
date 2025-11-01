import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /// 🧭 Fetches the current location coordinates and readable address.
  static Future<Map<String, dynamic>> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // ✅ Step 1: Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable them.');
    }

    // ✅ Step 2: Check & request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied. Please enable them from settings.',
      );
    }

    // ✅ Step 3: Get the current position
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double latitude = position.latitude;
    double longitude = position.longitude;

    // ✅ Step 4: Convert coordinates to a human-readable address
    String? address;
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        address =
            "${place.street}, ${place.locality}, ${place.administrativeArea}";
      }
    } catch (_) {
      // Fallback to coordinates if reverse geocoding fails
      address = "Lat: $latitude, Lng: $longitude";
    }

    // ✅ Step 5: Return a structured map
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  /// ⚙️ Optional: Use this to check if location services are enabled before fetching.
  static Future<bool> isServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// ⚠️ Optional: Check location permission status.
  static Future<LocationPermission> checkPermissionStatus() async {
    return await Geolocator.checkPermission();
  }
}
