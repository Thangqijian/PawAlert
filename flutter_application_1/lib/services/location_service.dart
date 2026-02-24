import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static const String _apiUrl = 'https://raw.githubusercontent.com/hazz1925/malaysian-states/master/states-cities.json';

  Future<Map<String, List<String>>> fetchLocations() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl)).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data.map((key, value) => MapEntry(key, List<String>.from(value)));
      }
      return _getFallbackData();
    } catch (e) {
      return _getFallbackData();
    }
  }

  Future<Map<String, String>> getCurrentLocationNames() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      return {
        'state': placemarks[0].administrativeArea ?? '',
        'city': placemarks[0].locality ?? placemarks[0].subAdministrativeArea ?? '',
      };
    }
    throw Exception("No location details found.");
  }

  Map<String, List<String>> _getFallbackData() {
    return {
      'Selangor': ['Petaling Jaya', 'Shah Alam', 'Subang Jaya'],
      'Kuala Lumpur': ['Kuala Lumpur'],
      'Negeri Sembilan': ['Seremban', 'Nilai'],
    };
  }
}